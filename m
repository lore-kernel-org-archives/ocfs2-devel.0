From: tristan <tristan.ye@oracle.com>
Date: Wed, 08 Sep 2010 17:07:50 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Add missing
 ocfs2_journal_acces_*() for couple of funcs in dir.c
In-Reply-To: <20100907211823.GD4364@wotan.suse.de>
References: <1282877169-4921-1-git-send-email-tristan.ye@oracle.com>
	<20100907211823.GD4364@wotan.suse.de>
Message-ID: <4C875266.2090106@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> On Fri, Aug 27, 2010 at 10:46:09AM +0800, Tristan Ye wrote:
>> To correctly journal the metadata in ocfs2, it's known for us to call
>> ocfs2_journal_access_*() and ocfs2_journal_dirty()to mark buffer dirty,
>> they are expected to exist in a pair.
>>
>> Whereas several funcs for dx-dirs manipulation were forgeting to call
>> appropriate ocfs2_journal_access*() to correctly journal the dirty
>> metadata, which may cause a BUG in jbd2, reporting a NULL pointer
>> gets ASSERTED in the journal buffer head.
>>
>> Currently, we found three functions being hurt in dir.c, all serving
>> for dx-dirs:
>>
>>     - ocfs2_dx_dir_transfer_leaf()
>
> NAK, this doesn't look to have a problem. Both clusters (new and old) are
> journal_accessed previously. Look at ocfs2_dx_dir_rebalance and ocfs2_dx_dir_format_cluster.

[<ffffffffa0480658>] ? ocfs2_journal_dirty+0x75/0xdc [ocfs2]
[<ffffffffa045f697>] ? ocfs2_find_dir_space_dx+0xd99/0x104f [ocfs2]
[<ffffffffa04aab1a>] ? ocfs2_buffer_cached+0xb3/0x124 [ocfs2]
[<ffffffffa047ffb1>] ? ocfs2_journal_access_dr+0x0/0xf [ocfs2]
[<ffffffffa0465af1>] ? ocfs2_prepare_dir_for_insert+0x8f5/0x136d [ocfs2]
[<ffffffffa045c408>] ? ocfs2_read_blocks+0x603/0x6fa [ocfs2]
[<ffffffffa0463dd3>] ? ocfs2_check_dir_for_entry+0xb1/0x117 [ocfs2]
[<ffffffffa046baaa>] ? ocfs2_inode_lock_full_nested+0xbe3/0xd9f [ocfs2]
[<ffffffffa0488f93>] ? ocfs2_mknod+0x298/0x1033 [ocfs2]
[<ffffffffa0489ebe>] ? ocfs2_create+0x95/0xfb [ocfs2]
[<ffffffff810cc72b>] ? inode_permission+0x66/0x92
[<ffffffff810cdb61>] ? vfs_create+0x90/0xe5
[<ffffffff810cdfd7>] ? do_last+0x2ed/0x5b5
[<ffffffff810cf0b7>] ? do_filp_open+0x1b8/0x50a
[<ffffffffa0467479>] ? ocfs2_remove_lockres_tracking+0x10/0x41 [ocfs2]
[<ffffffff811674ce>] ? _atomic_dec_and_lock+0x32/0x4c
[<ffffffff810c3642>] ? do_sys_open+0x55/0xe6
[<ffffffff810028ab>] ? system_call_fastpath+0x16/0x1b


 From above backstrace stack, I suspect the ocfs2_dx_dir_transfer_leaf 
was probably the victim function where its ocfs2_journal_dirty() was 
suffering.

Like what you said, ocfs2_dir_format_cluster and ocfs2_dx_dir_rebalance 
journal_accessed new/orig_dx_leaves. however, it's not suffice in our 
case, look at ocfs2_dx_dir_new_cluster() right before 
ocfs2_dx_dir_transfer_leaf(), it was calling ocfs2_insert_extent(), 
which probably might be the root cause I guess, growing a extent tree 
may need to call ocfs2_extent_trans which makes previous journal_access 
meaningless.

Therefore, we have to journal_access all new/orig_dx_leaves again after 
ocfs2_dx_dir_new_cluster().

>
>
>
>>     - ocfs2_remove_block_from_free_list()
>>     - ocfs2_recalc_free_list()
>
> Can you show me the stack traces for these please? It kinda looks like you
> just added journal_access calls randomly to make sure we cover everything.
> Not only does that confuse the code (look at how many functions turned from
> returning void to int) but it's redunant in most of the cases.
You're right here,

ocfs2_remove_block_from_free_list() and ocfs2_recalc_free_list() don't need to call journal_access on their own since the blocks being modified in these 2 funcs already get correctly journal_accessed previously.


> 	--Mark
>
> --
> Mark Fasheh
