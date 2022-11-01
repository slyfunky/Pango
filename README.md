<h1 align="center">Pango DNS Updater</h1>
<p align="center">This is a simple batch file DNS updater.<br></p>
<p align="left">It is using APIs from dynamic DNS services to keep your IP address current and syncing with your hostname provided by those services.<br></p>
<p align="left">Being an alternative to the DUC (DNS Update Client) of No-IP for Windows.</p>

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

<h2>References/Documentation</h2>
<p>No-IP API<br>
<a href="https://www.noip.com/pt-BR/integrate/request" target="_blank">Request</a> ,
<a href="https://www.noip.com/pt-BR/integrate/response" target="_blank">Response</a></p>

<p>Dynv6 API<br>
<a href="https://dynv6.com/docs/apis" target="_blank">Request</a> ,
<a href="https://gist.github.com/corny/7a07f5ac901844bd20c9" target="_blank">Reference</a></p>

<hr>

<h2>Running</h2>
<h4>Directory</h4>
<p><img src="https://user-images.githubusercontent.com/9852611/196879721-540f4be5-f455-43a6-831b-d502840133eb.png" width="556" height="314"></p>

<hr size="5" width="58%" align="left" >

<h4>Console</h4>
<p><img src="https://user-images.githubusercontent.com/9852611/199129768-9dbec49d-4dbf-4885-aae1-98d56e2fc63c.png" width="222" height="680">
  <img src="https://user-images.githubusercontent.com/9852611/196879637-ed6b5e45-21ad-47cc-9225-3de419920067.png" width="223" height="418"></p>

<hr size="5" width="63%" align="left" >

<h4>Windows Task Scheduler</h4>
<p><img src="https://user-images.githubusercontent.com/9852611/199132295-e61e9753-97c8-4323-8ef0-f5bf24c80711.png" width="480" height="258"></p>
<p><img src="https://user-images.githubusercontent.com/9852611/199131974-ed1f4110-0c71-4b40-992f-a14894663de5.png" width="315.50" height="239.50"></p>
<p><img src="https://user-images.githubusercontent.com/9852611/199132124-3789cae9-27eb-4e0c-a521-b662aa76fa5c.png" width="315.50" height="239.50"> <img src="https://user-images.githubusercontent.com/9852611/199132151-cf981230-f225-41ec-9664-2928c3991631.png" width="309.50" height="257"></p>
<p><img src="https://user-images.githubusercontent.com/9852611/199132211-3b944c7f-2507-4a8b-bfa8-17494fa51990.png" width="315.50" height="239.50"> <img src="https://user-images.githubusercontent.com/9852611/199132216-2dd7f413-a975-4eef-9697-b1b2fe1cb147.png" width="226.50" height="249.50"></p>
<p><img src="https://user-images.githubusercontent.com/9852611/199132250-2dceb520-2e5f-42ac-962c-d0262065045a.png" width="315.50" height="239.50"></p>
<p><img src="https://user-images.githubusercontent.com/9852611/199132262-895db756-f0a1-4484-9690-d108190644f6.png" width="315.50" height="239.50"></p>



