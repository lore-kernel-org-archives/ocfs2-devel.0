From: Gang He <GHe@suse.com>
Date: Mon, 3 Feb 2020 05:32:28 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix the oops problem when write
	cloned file
In-Reply-To: <de23176f-5b84-a785-80a2-0bdc8e3a0fab@linux.alibaba.com>
References: <20200121050153.13290-1-ghe@suse.com>
	<CH2PR18MB3206F418382332EB25130477CF000@CH2PR18MB3206.namprd18.prod.outlook.com>,
	<de23176f-5b84-a785-80a2-0bdc8e3a0fab@linux.alibaba.com>
Message-ID: <CH2PR18MB3206844EE94EC90A2CBFF85CCF000@CH2PR18MB3206.namprd18.prod.outlook.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joseph,

before calling ocfs2_refcount_cow() in the function ocfs2_prepare_inode_for_write(), we do not use inode buffer_head.
So, we can let buffer_head is NULL.
But, when we invoke ocfs2_refcount_cow() function, we have to pass inode buffer_head without NULL pointer.
That is why writing clone file will cause oops and kill the user-space process.

Thanks
Gang

________________________________________
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Sent: Monday, February 3, 2020 1:15 PM
To: Gang He; mark at fasheh.com; jlbec at evilplan.org; gechangwei at live.cn; Shuning Zhang
Cc: linux-kernel at vger.kernel.org; ocfs2-devel at oss.oracle.com; akpm at linux-foundation.org
Subject: Re: [PATCH] ocfs2: fix the oops problem when write cloned file



On 20/2/3 10:17, Gang He wrote:
> Hello Joseph, Changwei, Sunny and all,
>
> Could you help to review this patch?
> This patch will fix the oops problem caused by write ocfs2 clone files.
> The root cause is inode buffer head is NULL when calling ocfs2_refcount_cow.
> Secondly, we should use EX meta lock when calling ocfs2_refcount_cow.
>
Before commit e74540b28556, we may also use NULL buffer head in case of
overwrite, so why there is no such issue before?

Thanks,
Joseph
