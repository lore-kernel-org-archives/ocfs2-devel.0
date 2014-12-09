From: Xue jiufei <xuejiufei@huawei.com>
Date: Tue, 9 Dec 2014 14:38:01 +0800
Subject: [Ocfs2-devel] how can the [o2hb-x] kernel thread begin running
 in the ocfs2
In-Reply-To: <20141107183741199576112@h3c.com>
References: <mailman.16278.1415343839.23890.ocfs2-devel@oss.oracle.com>
	<20141107183741199576112@h3c.com>
Message-ID: <548698C9.605@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, 

Ocfs2 uses configfs to do user-space configuration tasks. When thread
mount.ocfs2 writes fd to /sys/kernel/config/cluster/{clustername}/heartbeat/{region_name}/dev,
kernel will trigger the callback. you can find the source code in
function o2cb_create_heartbeat_region() in ocfs2-tools package.

Thanks.
Xue Jiufei

On 2014/11/7 18:37, Zhangguanghui wrote:
> 
>     Hi
> 
> 
>             While mounting -t ocfs2 , the function ocfs2_fill_super is triggered.
> 
>     In the process, which specific function will trigger the callback of o2hb_region_dev_write,
> 
>     how can the [o2hb-x] kernel thread begin running?
> 
>      thanks
> 
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
