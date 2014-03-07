From: Younger Liu <younger.liucn@gmail.com>
Date: Fri, 07 Mar 2014 14:13:15 +0800
Subject: [Ocfs2-devel] [patch 08/11] ocfs2: should call
 ocfs2_journal_access_di() before ocfs2_delete_entry() in ocfs2_orphan_del()
In-Reply-To: <20140206232839.GP24361@wotan.suse.de>
References: <20140124204708.4CAEB5A4203@corp2gmr1-2.hot.corp.google.com>
	<20140206232839.GP24361@wotan.suse.de>
Message-ID: <5319637B.4050100@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2014/2/7 7:28, Mark Fasheh wrote:
> On Fri, Jan 24, 2014 at 12:47:07PM -0800, akpm at linux-foundation.org wrote:
>> From: Younger Liu <younger.liu@huawei.com>
>> Subject: ocfs2: should call ocfs2_journal_access_di() before ocfs2_delete_entry() in ocfs2_orphan_del()
>>
>> While deleting a file into orphan dir in ocfs2_orphan_del(), it calls
>> ocfs2_delete_entry() before ocfs2_journal_access_di().  If
>> ocfs2_delete_entry() succeeded and ocfs2_journal_access_di() failed, there
>> would be a inconsistency: the file is deleted from orphan dir, but orphan
>> dir dinode is not updated.
>>
>> So we need to call ocfs2_journal_access_di() before ocfs2_orphan_del().
> 
> I am confused by this. Re-reading the code in fs/ocfs2/dir.c,
> __ocfs2_delete_entry() takes great pains to mark the buffer head as part of
> the journal:
> 
> 	ocfs2_journal_access_func access = ocfs2_journal_access_db;
> 
> 	if (OCFS2_I(dir)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
> 		access = ocfs2_journal_access_di;
> 
> <snip>
> 
> 			status = access(handle, INODE_CACHE(dir), bh,
> 					OCFS2_JOURNAL_ACCESS_WRITE);
> 
> 
> Am I missing something here?
> 	--Mark
Hi Mark
   I am sorry to reply so late.
   I can understand your meaning, But if OCFS2_I(dir) is not inline
data, access = ocfs2_journal_access_db.
   Moreover, logically speaking, ocfs2_journal_access_di() should not
been called after ocfs2_delete_entry(). Otherwise, there is a potential
risk for inconsistency.

     --Younger
> 
> --
> Mark Fasheh
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
