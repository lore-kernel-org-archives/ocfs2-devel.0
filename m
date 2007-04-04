From: Sai Loganathan <sail@serverengines.com>
Date: Wed Apr  4 09:38:47 2007
Subject: [Ocfs2-devel] Setting up cluster
Message-ID: <009d01c776d7$68b420b0$2702140a@se19261f2cf9ed>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello,

I am trying to setup a simple 2 node cluster in sles10 64bit. This is just
for testing purposes to validate one of our iscsi products.

I followed the instructions from
http://wiki.novell.com/images/3/37/Exploring_HASF.pdf

After doing all the xml stuff for stoneith, when I do a mount I see that the
iscsi luns are not getting mounted. Moreover, when I do a /etc/init.d/o2cb
status, I see that heartbeat is not online/started but I have started the
heartbeat from /etc/init.d. I did this using both usermode and kernel mode.

 

Is there any other simple doc, which I could follow to setup a cluster?

 

Thanks,

Sai Logan




___________________________________________________________________________________
This message, together with any attachment(s), contains confidential and proprietary information of
ServerEngines LLC and is intended only for the designated recipient(s) named above. Any unauthorized
review, printing, retention, copying, disclosure or distribution is strictly prohibited.  If you are not the
intended recipient of this message, please immediately advise the sender by reply email message and
delete all copies of this message and any attachment(s). Thank you.
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20070404/e8aba6d5/attachment.html
