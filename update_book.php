<?php
// error_reporting(0);

if (!isset($_POST['userid']) || !isset($_POST['bookid']) || !isset($_POST['quantity'])) {
    $response = array('status' => 'failed', 'message' => 'Incomplete parameters', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$bookid = $_POST['bookid'];
$userid = $_POST['userid'];
$quantity = $_POST['quantity'];

// Check if the requested quantity is valid (greater than 0)
if ($quantity <= 0) {
    $response = array('status' => 'failed', 'message' => 'Invalid quantity', 'data' => null);
    sendJsonResponse($response);
    die();
}

// Check if the requested quantity is available
$sqlCheckQuantity = "SELECT book_qty FROM tbl_books WHERE book_id = '$bookid'";
$resultCheckQuantity = $conn->query($sqlCheckQuantity);

if ($resultCheckQuantity->num_rows > 0) {
    $row = $resultCheckQuantity->fetch_assoc();
    $availableQuantity = (int)$row['book_qty'];

    if ($quantity > $availableQuantity) {
        $response = array('status' => 'failed', 'message' => 'Insufficient quantity available', 'data' => null);
        sendJsonResponse($response);
        die();
    }
} else {
    $response = array('status' => 'failed', 'message' => 'Book not found', 'data' => null);
    sendJsonResponse($response);
    die();
}

// Perform the update operation
$sqlUpdateQuantity = "UPDATE tbl_cart SET cart_qty = '$quantity' WHERE buyer_id = '$userid' AND book_id = '$bookid'";
if ($conn->query($sqlUpdateQuantity) === TRUE) {
    $response = array('status' => 'success', 'message' => 'Quantity updated successfully', 'data' => null);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'message' => 'Failed to update quantity', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
