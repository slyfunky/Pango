<h1 align="center">Pango DNS Updater</h1>
<p align="center">This is a simple batch file DNS updater
It is using APIs from dynamic DNS services to keep your IP address current and syncing with your hostname provided by those services.
Being an alternative to the DUC (DNS Update Client) of No-IP for Windows.</p>

<hr>

<h2>Currently supported by</h2>
<ul>
<li>No-IP</li>
<li>Dynv6</li>
</ul>

<hr>

<h2>Introduction</h2>
<p>I was in a situation where my ISP didn't provide a dynamic public IP that pointed to my machine, because they put me in a CGNAT network configuration.<br>
My solution, however, was to use some DNS service that would support IPv6, if my provider provided it to me.<br>
Looking to use my old No-IP domain as a dns service, I saw that your client did not associate IPv6, only IPv4.<br>
It was then that I decided to write this script and add other dynamic DNS services.<br>
The script can be run as a command line utility or on a schedule as a service on windows (Windows Task Scheduler).</p>

<hr>

<h2>Usage</h2>
<p>Implementing update requests to the script based on their respective documentation we have the following settings to be made before executing.</p>

<h4>Configuration</h4>

> No-IP

| Parameters  | Description       |
| ----------- | ----------------- |
| `NOIPDNS`   | Your hostname.    |
| `NOIPTOKEN` | Yours credentials |

<p><em>Note</em><br>
Your credentials must be base64 encoded with ":" joining them into a single string.<br>

<blockquote>
Example<br>
Encoded auth string to <a href="https://codebeautify.org/base64-encode" target="_blank">base64</a> format<br>

| String  | Encoded       |
| ----------- | ----------------- |
| e-mail:password   | ZS1tYWlsOnBhc3N3b3Jk    |
</blockquote>

<hr size="5" width="58%" align="left" >

> Dynv6

| Parameters  | Description       |
| ----------- | ----------------- |
| `DYNVDNS`   | Your hostname.    |
| `DYNVTOKEN` | Your token |

<hr>

<h2>Author</h2>
<p>Renan Araujo</p>

<hr>

<h2>References/Documentation</h2>
<p>No-IP API<br>
<a href="https://www.noip.com/pt-BR/integrate/request" target="_blank">Request</a> ,
<a href="https://www.noip.com/pt-BR/integrate/response" target="_blank">Response</a></p>

<p>Dynv6 API<br>
<a href="https://dynv6.com/docs/apis" target="_blank">API Request</a></p>

<hr>