From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 05 May 2009 14:35:35 +0800
Subject: [Ocfs2-devel] [PATCH 07/39] ocfs2: Abstract extent split
	process.
In-Reply-To: <20090430235754.GM2762@mail.oracle.com>
References: <49F95A79.6040806@oracle.com>
	<1241045931-24607-7-git-send-email-tao.ma@oracle.com>
	<20090430235754.GM2762@mail.oracle.com>
Message-ID: <49FFDE37.5050509@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,
	sorry, I missed this mail last time.

Joel Becker wrote:
> On Thu, Apr 30, 2009 at 06:58:19AM +0800, Tao Ma wrote:
>> +static int ocfs2_change_extent_flag(handle_t *handle,
>> +				    struct ocfs2_extent_tree *et,
>> +				    u32 cpos, u32 len, u32 phys,
>> +				    struct ocfs2_alloc_context *meta_ac,
>> +				    struct ocfs2_cached_dealloc_ctxt *dealloc,
>> +				    int new_flags, int clear_flags)
> 
> 	This function wants a comment about what it is for.
> 
>> +	rec = &el->l_recs[index];
>> +	if ((new_flags && (rec->e_flags & new_flags)) ||
>> +	    (clear_flags && !(rec->e_flags & clear_flags))) {
>> +		ret = -EIO;
>> +		mlog_errno(ret);
>> +		goto out;
>> +	}
> 
> 	Do we want to log some details as to where the -EIO came from?
> Something like "Owner %llu tried to set flags on an extent that already
> had them" and "tried to clear flags on an extent that didn't have them"?
yeah, I will add the mlog.
> 
>> +	if (new_flags)
>> +		split_rec.e_flags |= new_flags;
>> +	else
>> +		split_rec.e_flags &= ~clear_flags;
> 
> 	This code here assumes that the caller sets new_flags or
> clear_flags but not both.  Do we want that?  Either we allow both, and
> we honor both, or we should BUG_ON(new_flags && clear_flags).
um, actually the b-tree code doesn't care it, so it means that we can 
add a flag while clearing a flag in the same transaction here. So I will 
change it to allow them to coexist. Maybe we need it in the future. ;) 
Thanks.

Regards,
Tao
