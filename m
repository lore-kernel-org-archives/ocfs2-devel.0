From: Wangyan <wangyan122@huawei.com>
Date: Thu, 28 May 2020 08:43:27 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: clear links count in
 ocfs2_mknod() if an error occurs
In-Reply-To: <20200527155220.df299b5a7326f1e63f366113@linux-foundation.org>
References: <d8147c41-fb2b-bdf7-b660-1f3c8448c33f@huawei.com>
	<20200527155220.df299b5a7326f1e63f366113@linux-foundation.org>
Message-ID: <be5b2f96-51bd-350d-abff-66e203ff1561@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Yes, I think these fixes should be backported into -stable kernels.

On 2020/5/28 6:52, Andrew Morton wrote:
> On Tue, 26 May 2020 15:45:35 +0800 Wangyan <wangyan122@huawei.com> wrote:
> 
>> In this condition, the inode can not be wiped when error happened.
>> ocfs2_mkdir()
>>   ->ocfs2_mknod()
>>     ->ocfs2_mknod_locked()
>>       ->__ocfs2_mknod_locked()
>>         ->ocfs2_set_links_count() // i_links_count is 2
>>     -> ... // an error accrue, goto roll_back or leave.
>>     ->ocfs2_commit_trans()
>>     ->iput(inode)
>>       ->evict()
>>         ->ocfs2_evict_inode()
>>           ->ocfs2_delete_inode()
>>             ->ocfs2_inode_lock()
>>               ->ocfs2_inode_lock_update()
>>                 ->ocfs2_refresh_inode()
>>                   ->set_nlink();    // inode->i_nlink is 2 now.
>>             /* if wipe is 0, it will goto bail_unlock_inode */
>>             ->ocfs2_query_inode_wipe()
>>               ->if (inode->i_nlink) return; // wipe is 0.
>>             /* inode can not be wiped */
>>             ->ocfs2_wipe_inode()
>> So, we need clear links before the transaction committed.
> 
> Do we think these fixes should be backported into -stable kernels?
> 
> 
> 
> .
> 
