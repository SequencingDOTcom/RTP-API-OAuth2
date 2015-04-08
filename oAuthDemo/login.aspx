<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="oAuthDemo.login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <h2>Sequencing.com oAuth2 Demo</h2>
    <asp:Button ID="Login" runat="server" Text="Login to Sequencing.com" OnClick="Login_Click" />
    </div>
    </form>
</body>
</html>
