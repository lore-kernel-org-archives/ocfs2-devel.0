From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Mon, 3 Feb 2020 13:15:30 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix the oops problem when write
	cloned file
In-Reply-To: <CH2PR18MB3206F418382332EB25130477CF000@CH2PR18MB3206.namprd18.prod.outlook.com>
References: <20200121050153.13290-1-ghe@suse.com>
	<CH2PR18MB3206F418382332EB25130477CF000@CH2PR18MB3206.namprd18.prod.outlook.com>
Message-ID: <de23176f-5b84-a785-80a2-0bdc8e3a0fab@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



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
