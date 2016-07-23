From: Gechangwei <ge.changwei@h3c.com>
Date: Sat, 23 Jul 2016 08:54:27 +0000
Subject: [Ocfs2-devel] A question on AST
Message-ID: <63ADC13FD55D6546B7DECE290D39E373220A80D0@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,
I have a question on AST related procedure.
If a lock request has been sent to lock resource?s owner node right before this owner node crashes.
Then no one will send back to the requested node with AST, this will cause the requested node waiting for a completion forever.
Is this an issue that we can bear with?
Or OCFS2 can handle above exception?

I am looking forward to your reply.

Thanks.

Br.

Chauncey Ge.
-------------------------------------------------------------------------------------------------------------------------------------
????????????????????????????????????????
????????????????????????????????????????
????????????????????????????????????????
???
This e-mail and its attachments contain confidential information from H3C, which is
intended only for the person or entity whose address is listed above. Any use of the
information contained herein in any way (including, but not limited to, total or partial
disclosure, reproduction, or dissemination) by persons other than the intended
recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
by phone or email immediately and delete it!
