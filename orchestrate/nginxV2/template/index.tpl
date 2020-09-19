<!DOCTYPE html>
<html>
	<head>
		<title>Text</title>
		<style type="text/css">
			body {
				padding: 20px;}
			h3 {
				font-weight: normal;
				color: #00b388;
				margin: 0px;}
			h3 {
				font-family: Georgia, Times, serif;
				line-height: 1.4em;
				color: #00b388;}
			p.intro:first-line {
				font-weight: bold;}
			.credits {
				font-style: italic;	
				text-align: right;}
		</style>
	</head>
	<body>
		<h3>Application: ${applicationName}</h3>
		<h3>Virtual Machine: ${vmName}</h3>
		<h3>Private IP: ${privateIP}</h3>
		<h3>Public IP: ${publicIP}</h3>
	</body>
</html>