From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Thu, 12 Mar 2020 10:01:51 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix a null pointer derefrence in
 ocfs2_block_group_clear_bits()
In-Reply-To: <20200311184031.a850f8e3dbd664b599654303@linux-foundation.org>
References: <1d38573d-61c7-be60-334e-c263caf7465c@huawei.com>
	<c56390f0-9f01-cd71-0b8e-b83d746bab74@huawei.com>
	<f702081e-1953-c2c1-76e4-f441302ab2f3@huawei.com>
	<32e99737-b992-d9b7-5a97-a17168dde88f@huawei.com>
	<20200311184031.a850f8e3dbd664b599654303@linux-foundation.org>
Message-ID: <c073296c-ac3b-6e56-0786-5dac16cc1feb@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Andrew,

On 2020/3/12 09:40, Andrew Morton wrote:

<snip>

> 
> (top-posting repaired)
> 
>> ping ?
>> cc Andrew Morton
> 
> There's something dreadfully wrong with the ocfs2-devel mailing list. 
> I almost never receive patches when people add me to cc.  I've never
> seen much of a pattern to it - it just drops stuff everywhere.
> 
> Who is the admin for this list?  Can we please move it to kernel.org?
> 

From the web page info, it was run by Srinivas Eeda, but I am not sure
whether he still maintains the list now.
So current workaround may be, sending to you directly along with cc to
the mail list.

Thanks,
Joseph

> Regarding this patch, I did actually receive one email from the server.
> From Joseph:
> 
> : > +		if (!undo_bg)
> : > +			mlog(ML_NOTICE, "%s: group descriptor # %llu (device %s) journal "
> : > +					"b_committed_data had been cleared.\n",
> : > +					OCFS2_SB(alloc_inode->i_sb)->uuid_str,
> : > +					(unsigned long long)le64_to_cpu(bg->bg_blkno),
> : > +					alloc_inode->i_sb->s_id);
> : 
> : Seems a kind of workaround.
> : I am worrying about other abnormal cases of NULL b_committed_data, it
> : may lead to a corrupt filesystem.
> : So how about isolating the journal abort case?
> 
