From: Coly Li <coyli@suse.de>
Date: Wed, 03 Dec 2008 00:36:27 +0800
Subject: [Ocfs2-devel] [nov 29] what is ocfs2_lock() used for ?
In-Reply-To: <49348BF5.8040004@oracle.com>
References: <4930FDE8.3070103@suse.de> <49348BF5.8040004@oracle.com>
Message-ID: <4935640B.5010508@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Tao Ma Wrote:
> 
> 
> Coly Li wrote:
>> Hi List,
>>
>> In Linus tree, I find ocfs2_lock() in fs/ocfs2/locks.c, this function
>> can not be found from sles10
>> sp2 tree. Also I don't find any other code calling ocfs2_lock().
> It is an operation in file_operations. git log fs/ocfs2/locks.c shows
> that it is added by commit 53da4939f349d4edd283b043219221ca5b78e4d4.
> 
> commit 53da4939f349d4edd283b043219221ca5b78e4d4
> Author: Mark Fasheh <mfasheh@suse.com>
> Date:   Mon Jul 21 14:29:16 2008 -0700
> 
>     ocfs2: POSIX file locks support
> 
>     This is actually pretty easy since fs/dlm already handles the bulk
> of the work. The Ocfs2 userspace cluster stack module already uses
> fs/dlm as the underlying lock manager, so I only had to add the right
> calls.
> 
>     Cluster-aware POSIX locks ("plocks") can be turned off by the same
> means at UNIX locks - mount with 'noflocks', or create a local-only
> Ocfs2 volume. Internally, the file system uses two sets of
> file_operations, depending on whether cluster aware plocks is required.
> This turns out to be easier than implementing local-only versions of
> ->lock.
> 
>     Signed-off-by: Mark Fasheh <mfasheh@suse.com>

Thanks for your explaining, really helpful.

-- 
Coly Li
SuSE PRC Labs
