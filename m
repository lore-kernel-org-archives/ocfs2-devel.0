From: Changwei Ge <ge.changwei@h3c.com>
Date: Thu, 1 Mar 2018 00:40:39 +0000
Subject: [Ocfs2-devel] [PATCH 0/6] ocfs2: Fix various quota recovery
References: <20180228111802.23967-1-jack@suse.cz>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373F292A975@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jan,

On 2018/2/28 19:18, Jan Kara wrote:
> Hello,
> 
> this patch series fixes various issues I've found with ocfs2 quota recovery.
> There were possible quota recovery failures or deadlocks when it raced with
> umount in a wrong way. Also quota recovery would fail if the filesystem was
> mounted read-only. The final patch is an unrelated fix for mount option
> parsing I've found when testing my changes. Warning! I've tested these
> patches only in local mode (as I don't have ocfs2 clustered setup available
> for testing). Can someone please verify things also work properly in clustered
> mode when recovery of quotas from other nodes happens? Thanks!

We will perform a test applying your patch set in cluster mode ocfs2 and give a 
feedback later.

Thanks,
Changwei

> 
> 								Honza
> 
