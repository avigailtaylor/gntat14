<?php
if(isset($_POST['email'])) {
     
    // CHANGE THE TWO LINES BELOW
    $email_to = "avigailtaylor@gmail.com";
     
    $email_subject = "GeneNet Toolbox Question (from gntat14 project)";
     
     
    function died($error) {
        // your error code can go here
        echo "Sorry, there is at least one error with the form you submitted. ";
        echo "Error(s).<br /><br />";
        echo $error."<br /><br />";
        echo "Please fix the error(s) and resubmit your form.<br /><br />";
        die();
    }
     
    // validation expected data exists
    if(!isset($_POST['first_name']) ||
        !isset($_POST['last_name']) ||
        !isset($_POST['email']) ||
        !isset($_POST['questions'])) {
        died('Sorry, but there appears to be a problem with the form you submitted.');       
    }
     
    $first_name = $_POST['first_name']; // required
    $last_name = $_POST['last_name']; // required
    $email_from = $_POST['email']; // required
    $questions = $_POST['questions']; // required
     
    $error_message = "";
    $email_exp = '/^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/';
  if(!preg_match($email_exp,$email_from)) {
    $error_message .= 'The email address you entered is not valid.<br />';
  }
    $string_exp = "/^[A-Za-z .'-]+$/";
  if(!preg_match($string_exp,$first_name)) {
    $error_message .= 'The first name you entered is not valid.<br />';
  }
  if(!preg_match($string_exp,$last_name)) {
    $error_message .= 'The last name you entered is not valid.<br />';
  }
  if(strlen($questions) < 2) {
    $error_message .= 'You left the Questions field blank.<br />';
  }
  if(strlen($error_message) > 0) {
    died($error_message);
  }
    $email_message = "Form details below.\n\n";
     
    function clean_string($string) {
      $bad = array("content-type","bcc:","to:","cc:","href");
      return str_replace($bad,"",$string);
    }
     
    $email_message .= "First Name: ".clean_string($first_name)."\n";
    $email_message .= "Last Name: ".clean_string($last_name)."\n";
    $email_message .= "Email: ".clean_string($email_from)."\n";
    $email_message .= "Questions: ".clean_string($questions)."\n";
     
     
// create email headers
$headers = 'From: '.$email_from."\r\n".
'Reply-To: '.$email_from."\r\n" .
'X-Mailer: PHP/' . phpversion();
@mail($email_to, $email_subject, $email_message, $headers);  
?>
 
<!-- place your own success html below -->
 
Thank you for your question; I will endevour to answer it as soon as possible.
 
<?php
}
die();
?>
