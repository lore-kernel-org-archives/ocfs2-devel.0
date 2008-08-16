From: Tao Ma <tao.ma@oracle.com>
Date: Sat, 16 Aug 2008 17:49:10 +0800
Subject: [Ocfs2-devel] [PATCH 04/15] Make extend allocation generic.
In-Reply-To: <20080815192310.GC22815@mail.oracle.com>
References: <489A94F4.90903@oracle.com>
	<1218061894-7693-4-git-send-email-tao.ma@oracle.com>
	<20080814200144.GB28875@mail.oracle.com>
	<48A52CDE.4020706@oracle.com>
	<20080814234722.GF17664@mail.oracle.com>
	<48A541D5.2080102@oracle.com>
	<20080815062634.GA28988@mail.oracle.com>
	<48A5A40A.4010004@oracle.com>
	<20080815192310.GC22815@mail.oracle.com>
Message-ID: <48A6A296.5040307@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker wrote:
> On Fri, Aug 15, 2008 at 11:43:06PM +0800, Tao Ma wrote:
>>>>>>>> +int ocfs2_add_clusters_in_btree(struct ocfs2_super *osb,
>>>>>>>> +				struct inode *inode,
>>>>>>>> +				u32 *logical_offset,
>>>>>>>> +				u32 clusters_to_add,
>>>>>>>> +				int mark_unwritten,
>>>>>>>> +				struct buffer_head *root_bh,
>>>>>>>> +				struct ocfs2_extent_list *root_el,
>>>>>>>> +				handle_t *handle,
>>>>>>>> +				struct ocfs2_alloc_context *data_ac,
>>>>>>>> +				struct ocfs2_alloc_context *meta_ac,
>>>>>>>> +				enum ocfs2_alloc_restarted *reason_ret,
>>>>>>>> +				enum ocfs2_extent_tree_type type)
> 
>> But as for the original case which you ask me not to pass root_el, it  
>> isn't suitable since root_el need less stack length and more readable  
>> than we initiate a ocfs2_extent_tree here.
> 
> 	That's a 12 argument function there.  That's ugly.  This isn't
> about actual stack usage (you're right, we don't gain stack in my
> scheme).  It's about readable functions.
> 	In fact, struct ocfs2_alloc_context exists so that Mark could
> pass one _ac down to a function rather than 5 arguments.
> 	Why aren't you passing a struct ocfs2_extent_tree to this
> function anyway?  You could do it in the caller, pass it down, and then
> this function takes one *et rather than *root_bh+*root_el+type.  Just a
> thought.
I'd like to limit ocfs2_extent_tree in fs/ocfs2/alloc.c, so that the 
other files(dir.c, file.c, aops.c) don't need to know this structure. So 
is it suitable here?
> 	Mark knows this code better than I, so if he jumps in and says
> "I find this 12 argument function more readable than what you propose",
> I will happily consider myself outvoted :-)
OK, so Mark, please give me your vote. ;)

Regards,
Tao
