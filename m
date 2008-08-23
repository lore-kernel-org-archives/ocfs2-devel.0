From: Parapuram, Sajith <sajith.parapuram@diebold.com>
Date: Sat, 23 Aug 2008 04:23:23 -0000
Subject: [Ocfs2-devel] OCFS2 upgrade on OEL 4.4 server
Message-ID: <C3ED57D913C9684EB0C9F891003BC66BA767E7@usncex18.ad.diebold.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

We are using OEL 4.4 server as Oracle Concurrent tier, we have two
servers in the cluster. We have upgraded the OCFS2 from 1.2.7 to 1.2.9-1
about a week back in the DEV server. I have read about OCFS2 1.4 and it
seems that the performance has improved in OCFS2 1.4. We have OCFS2
performance issues, we are facing this in prod as the file count
increases in a log and out directories under prodcomn in the Oracle Conc
tier. As the file count increases the load on the data base server
increases and we have to do the conc tier outage and move the files in
the log and out directories to improve the performance again. Please let
me know if it is possible to upgrade the OCFS2 to 1.4 on OEL 4.4
servers.

Thanks

Sajith Parapuram
Diebold Software Services Pvt Ltd.
The V-Ascendas IT Park
C-3, Mariner Block
Madhapur, Hyderabad 500 081
Mobile:- 91 9908015570
Desk Tel:- 91 40 66164044
Fax:- 91 40 66164115
parapus at diebold.com


-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080823/cfed165b/attachment-0001.html 
