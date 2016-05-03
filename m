From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Tue, 3 May 2016 09:35:38 -0700
Subject: [Ocfs2-devel] what MLE wants to do?
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E373CAFB13@H3CMLB14-EX.srv.huawei-3com.com>
References: <63ADC13FD55D6546B7DECE290D39E373CAFB13@H3CMLB14-EX.srv.huawei-3com.com>
Message-ID: <5728D35A.1060507@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In simple terms, mle's get into life at the beginning of the lock 
mastery and ends at the end of lock mastery(either new lockres or during 
lockres migration). It's purpose is to handle the race when more than 
one node try to master or find master of a lockres.


On 05/03/2016 02:23 AM, Gechangwei wrote:
>
> Hi OCFS2 experts,
>
> Recently, I am working hard on OCFS2 DLM related code. I think it is 
> an essential part of OCFS2 which must be mastered.
>
> But I was confused with MLE (stands for master list entry) related 
> procedure.
>
> Would you please introduce me some study material covering MLE or just 
> directly give me a clue on what MLE wants to do briefly via an email.
>
> Thanks a lot.
>
> Br.
>
> Gechangwei
>
> H3C Technologies Co., Limited
>
> > ----------------------------------------------------------------------
>
> > ------
>
> > ---------------------------------------------------------
>
> -------------------------------------------------------------------------------------------------------------------------------------
> ??????????????????????????????????? 
> ?????
> ??????????????????????????????????? 
> ?????
> ??????????????????????????????????? 
> ?????
> ???
> This e-mail and its attachments contain confidential information from 
> H3C, which is
> intended only for the person or entity whose address is listed above. 
> Any use of the
> information contained herein in any way (including, but not limited 
> to, total or partial
> disclosure, reproduction, or dissemination) by persons other than the 
> intended
> recipient(s) is prohibited. If you receive this e-mail in error, 
> please notify the sender
> by phone or email immediately and delete it!
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20160503/57a91d3d/attachment.html 
