/obj/item/weapon/wireless/PDA/proc/GetHomepage()
	var/dat = {"
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>PDA</title>
<style type="text/css">
<!--
.Wrapper {
	height: 300px;
	width: 200px;
	text-align: center;
}
.MiddleWrapper {
	position: relative;
	top: auto;
	text-align: center;
}
.Bottom {
	bottom: auto;
	position: absolute;
	width: 167px;
	height: 30px;
	top: 246px;
	left: 10px;
	font-weight: bold;
	color: #000;
	font-family: Verdana, Geneva, sans-serif;
	font-size: 12px;
}
.Wrapper p {
	font-family: Verdana, Geneva, sans-serif;
	color: #999;
	font-weight: bold;
}
.Wrapper .MiddleWrapper table tr td {
	font-family: Verdana, Geneva, sans-serif;
	color: #999;
	font-weight: bold;
}
body {
	background-image: url(http://baystation12.co.cc/ingame/PDAlbkg.png);
	background-repeat: no-repeat;
	overflow:hidden;}

html {
	overflow:hidden;}
}
-->
</style>
</head>

<body>
<div class="Wrapper">
  <p>&nbsp;</p>
  <p>Nanotransen PDA software 1.3</p>
  <div class="MiddleWrapper">
    <table width="100%" border="0" cellpadding="2">
      <tr>
        <td><p>Communications</p></td>
      </tr>
      <tr>
        <td>System settings</td>
      </tr>
      <tr>
        <td>Flash-light</td>
      </tr>
    </table>
  </div>
  <div class="Bottom">Currently connected to &quot;Network tech office&quot;</div>
</div>
</body>
</html>


"}
	return dat