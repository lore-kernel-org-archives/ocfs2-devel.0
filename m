From: Joseph Qi <joseph.qi@huawei.com>
Date: Thu, 28 Aug 2014 18:37:31 +0800
Subject: [Ocfs2-devel] Can one single file's size is larger than 2T in
 one ocfs2 cluseter?
In-Reply-To: <71604351584F6A4EBAE558C676F37CA42EC65836@H3CMLB14-EX.srv.huawei-3com.com>
References: <71604351584F6A4EBAE558C676F37CA42EC65836@H3CMLB14-EX.srv.huawei-3com.com>
Message-ID: <53FF066B.9050109@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2014/8/28 17:49, Guozhonghua wrote:
> Hi all,
> 
> As we have test the OCFS2, and create one image file to be used as one virtual machine?s disk, it size is more than 2T, but its stats information is error.
> 
> Is file size limited to 2T? Or any other way to avoid its?
> 
AFAIK, no such limit.
Theoretically it supports maximum 4PB file. And we've tested 10T.

>  
> 
> Thanks
> 
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
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
