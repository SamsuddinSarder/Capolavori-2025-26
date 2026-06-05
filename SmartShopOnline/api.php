<?php

session_start();

header("Content-Type: application/json");

class SmartMarketAPI
{
    private PDO $db;

    public function __construct()
    {
        try
        {
            $this->db = new PDO(
                "mysql:host=localhost;dbname=smartmarket;charset=utf8mb4",
                "root",
                ""
            );

            $this->db->setAttribute(
                PDO::ATTR_ERRMODE,
                PDO::ERRMODE_EXCEPTION
            );
        }
        catch(PDOException $e)
        {
            $this->error($e->getMessage());
        }
    }

    public function run()
    {
        $input = json_decode(
            file_get_contents("php://input"),
            true
        );

        if(!$input)
        {
            $this->error("JSON non valido");
        }

        $action = $input["action"] ?? "";

        switch($action)
        {
            case "register":
                $this->register($input);
                break;

            case "login":
                $this->login($input);
                break;

            case "logout":
                $this->logout();
                break;

            case "products":
                $this->products();
                break;

            case "barcode":
                $this->barcode($input);
                break;

            case "open_receipt":
                $this->openReceipt($input);
                break;

            case "add_product":
                $this->addProduct($input);
                break;

            case "close_receipt":
                $this->closeReceipt();
                break;

            default:
                $this->error("Azione non valida");
        }
    }

    private function register($data)
    {
        // Controlla email duplicata
        $check = $this->db->prepare(
            "SELECT id FROM utenti WHERE email=?"
        );
        $check->execute([$data["email"]]);
        if($check->fetch())
        {
            $this->error("Email già registrata");
        }

        $stmt = $this->db->prepare(
            "INSERT INTO utenti
            (nome,cognome,email,password_hash)
            VALUES (?,?,?,?)"
        );

        $stmt->execute([
            $data["nome"],
            $data["cognome"],
            $data["email"],
            password_hash(
                $data["password"],
                PASSWORD_DEFAULT
            )
        ]);

        $this->success("Registrazione completata");
    }

    private function login($data)
    {
        $stmt = $this->db->prepare(
            "SELECT * FROM utenti
             WHERE email=?"
        );

        $stmt->execute([
            $data["email"]
        ]);

        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if(!$user)
        {
            $this->error("Utente non trovato");
        }

        if(
            !password_verify(
                $data["password"],
                $user["password_hash"]
            )
        )
        {
            $this->error("Password errata");
        }

        $_SESSION["user"] = $user["id"];

        // Ritorna nome e cognome al frontend
        $this->response([
            "id"      => $user["id"],
            "nome"    => $user["nome"],
            "cognome" => $user["cognome"],
            "email"   => $user["email"],
            "ruolo"   => $user["ruolo"]
        ]);
    }

    private function logout()
    {
        session_destroy();
        $this->success("Logout effettuato");
    }

    private function products()
    {
        // Vista con JOIN categoria per avere il nome
        $stmt = $this->db->query(
            "SELECT
                p.id,
                p.barcode,
                p.nome,
                p.descrizione,
                p.prezzo_netto,
                p.iva,
                ROUND(p.prezzo_netto + (p.prezzo_netto * p.iva / 100), 2) AS prezzo_ivato,
                p.giacenza,
                c.nome AS categoria
             FROM prodotti p
             LEFT JOIN categorie c ON p.categoria_id = c.id
             WHERE p.attivo = 1
             ORDER BY c.nome, p.nome"
        );

        $this->response([
            "products" =>
            $stmt->fetchAll(PDO::FETCH_ASSOC)
        ]);
    }

    private function barcode($data)
    {
        $stmt = $this->db->prepare(
            "SELECT
                p.*,
                c.nome AS categoria
             FROM prodotti p
             LEFT JOIN categorie c ON p.categoria_id = c.id
             WHERE p.barcode = ?"
        );

        $stmt->execute([
            $data["barcode"]
        ]);

        $product = $stmt->fetch(PDO::FETCH_ASSOC);

        if(!$product)
        {
            $this->error("Prodotto non trovato");
        }

        $this->response($product);
    }

    private function openReceipt($data)
    {
        $cliente = null;

        if(!empty($data["tessera"]))
        {
            $stmt = $this->db->prepare(
                "SELECT id
                 FROM clienti
                 WHERE codice_tessera=?"
            );

            $stmt->execute([
                $data["tessera"]
            ]);

            $cliente =
            $stmt->fetchColumn();
        }

        $stmt = $this->db->prepare(
            "INSERT INTO scontrini
            (cliente_id,cassa_id)
            VALUES (?,?)"
        );

        $stmt->execute([
            $cliente,
            $data["cassa"]
        ]);

        $_SESSION["receipt"] =
        $this->db->lastInsertId();

        $this->success("Scontrino aperto");
    }

    private function addProduct($data)
    {
        if(!isset($_SESSION["receipt"]))
        {
            $this->error("Nessuno scontrino aperto");
        }

        $stmt = $this->db->prepare(
            "SELECT *
             FROM prodotti
             WHERE barcode=?"
        );

        $stmt->execute([
            $data["barcode"]
        ]);

        $product =
        $stmt->fetch(PDO::FETCH_ASSOC);

        if(!$product)
        {
            $this->error("Prodotto non trovato");
        }

        $receipt =
        $_SESSION["receipt"];

        $check = $this->db->prepare(
            "SELECT *
             FROM righe_scontrino
             WHERE scontrino_id=?
             AND prodotto_id=?"
        );

        $check->execute([
            $receipt,
            $product["id"]
        ]);

        $row =
        $check->fetch(PDO::FETCH_ASSOC);

        if($row)
        {
            $update =
            $this->db->prepare(
                "UPDATE righe_scontrino
                 SET quantita=quantita+1
                 WHERE id=?"
            );

            $update->execute([
                $row["id"]
            ]);
        }
        else
        {
            $insert =
            $this->db->prepare(
                "INSERT INTO righe_scontrino
                (
                    scontrino_id,
                    prodotto_id,
                    quantita,
                    prezzo_unitario,
                    iva
                )
                VALUES (?,?,?,?,?)"
            );

            $insert->execute([
                $receipt,
                $product["id"],
                1,
                $product["prezzo_netto"],
                $product["iva"]
            ]);
        }

        $this->success("Prodotto aggiunto");
    }

    private function closeReceipt()
    {
        if(!isset($_SESSION["receipt"]))
        {
            $this->error("Nessuno scontrino");
        }

        $receipt =
        $_SESSION["receipt"];

        $stmt = $this->db->prepare(
            "SELECT *
             FROM righe_scontrino
             WHERE scontrino_id=?"
        );

        $stmt->execute([
            $receipt
        ]);

        $rows =
        $stmt->fetchAll(PDO::FETCH_ASSOC);

        $netto = 0;
        $iva = 0;

        foreach($rows as $r)
        {
            $tot =
            $r["prezzo_unitario"] *
            $r["quantita"];

            $netto += $tot;

            $iva +=
            $tot *
            ($r["iva"]/100);
        }

        $lordo =
        $netto + $iva;

        $update =
        $this->db->prepare(
            "UPDATE scontrini
             SET
             totale_netto=?,
             totale_iva=?,
             totale_lordo=?
             WHERE id=?"
        );

        $update->execute([
            $netto,
            $iva,
            $lordo,
            $receipt
        ]);

        unset(
            $_SESSION["receipt"]
        );

        $this->response([
            "netto"  => round($netto, 2),
            "iva"    => round($iva, 2),
            "lordo"  => round($lordo, 2)
        ]);
    }

    private function success($message)
    {
        echo json_encode([
            "success" => true,
            "message" => $message
        ]);
        exit;
    }

    private function error($message)
    {
        echo json_encode([
            "success" => false,
            "message" => $message
        ]);
        exit;
    }

    private function response($data)
    {
        echo json_encode([
            "success" => true,
            "data"    => $data
        ]);
        exit;
    }
}

(new SmartMarketAPI())->run();
