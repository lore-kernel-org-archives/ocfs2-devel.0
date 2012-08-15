From: =?utf-8?Q?Marek_Kr=C3=B3likowski?= <admin@wset.edu.pl>
Date: Wed, 15 Aug 2012 10:29:18 +0200
Subject: [Ocfs2-devel] OCFS + QUOTA - Many errors in dmesg - Mayby fix that?
Message-ID: <AF11BCE64D6647C0B14576AA905DF52A@SERWER>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hey
I see You remove ocfs2_global_read_info errors from dmesg can You remove other stupid errors too?
I got kernel 3.2.27 with enable quota on OCFS2 and i got many many errors likes:

(local,19395,1):ocfs2_write_begin:1953 ERROR: status = ?122

(courier-imapd,23881,13):ocfs2_rename:1474 ERROR: status = -122

(courier-imapd,23881,13):ocfs2_extend_dir:3363 ERROR: status = -122

(courier-imapd,23881,13):ocfs2_prepare_dx_dir_for_insert:4305 ERROR: status = -122

(local,32013,3):ocfs2_link:678 ERROR: status = -122

(local,32013,3):ocfs2_prepare_dir_for_insert:4392 ERROR: status = -122

(courier-imapd,27444,19):ocfs2_mknod:459 ERROR: status = -122

(courier-imapd,27444,19):ocfs2_create:629 ERROR: status = -122

s2_prepare_dir_for_insert:4367 ERROR: status = ?122


This all errors is when someone is over quota and try use imap/pop3/postfix.

Thanks
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20120815/9db5abb9/attachment.html 
