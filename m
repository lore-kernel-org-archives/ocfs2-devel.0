From: Eric Ren <zren@suse.com>
Date: Mon, 25 Jul 2016 15:55:16 +0800
Subject: [Ocfs2-devel] A question on AST
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E373220A80D0@H3CMLB12-EX.srv.huawei-3com.com>
References: <63ADC13FD55D6546B7DECE290D39E373220A80D0@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <89f74e3b-0613-953a-e2da-1e84a07a4e8c@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

On 07/23/2016 04:54 PM, Gechangwei wrote:
> Hi,
> I have a question on AST related procedure.
> If a lock request has been sent to lock resource?s owner node right before this owner node crashes.
> Then no one will send back to the requested node with AST, this will cause the requested node waiting for a completion forever.
> Is this an issue that we can bear with?
> Or OCFS2 can handle above exception?

A recovery process will be started in your case. As part of the last stage of recovery, it 
will grants locks that were blocked by the dead node.

Regards,
Eric

>
> I am looking forward to your reply.
>
> Thanks.
>
> Br.
>
> Chauncey Ge.
> -------------------------------------------------------------------------------------------------------------------------------------
> ????????????????????????????????????????
> ????????????????????????????????????????
> ????????????????????????????????????????
> ???
> This e-mail and its attachments contain confidential information from H3C, which is
> intended only for the person or entity whose address is listed above. Any use of the
> information contained herein in any way (including, but not limited to, total or partial
> disclosure, reproduction, or dissemination) by persons other than the intended
> recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
> by phone or email immediately and delete it!
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
