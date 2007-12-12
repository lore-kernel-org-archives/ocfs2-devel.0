From: tao.ma <tao.ma@oracle.com>
Date: Wed Dec 12 23:06:54 2007
Subject: [Ocfs2-devel] [PATCH 3/3] Implement "GROUP_ADD" for online	resize,
	take 2
In-Reply-To: <20071130232004.GF28607@ca-server1.us.oracle.com>
References: <20071127081123.GA4345@tma-pc1.cn.oracle.com>
	<20071127082149.GA4486@tma-pc1.cn.oracle.com>
	<20071130232004.GF28607@ca-server1.us.oracle.com>
Message-ID: <4760D978.8080404@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
>
>> +	le32_add_cpu(&cr->c_total, input->clusters * cl_bpc);
>> +	le32_add_cpu(&cr->c_free, input->frees * cl_bpc);
>> +
>> +	le32_add_cpu(&fe->id1.bitmap1.i_total, input->clusters *cl_bpc);
>> +	le32_add_cpu(&fe->id1.bitmap1.i_used,
>> +		     (input->clusters - input->frees) * cl_bpc);
>> +	le32_add_cpu(&fe->i_clusters, input->clusters);
>> +	le64_add_cpu(&fe->i_size, input->clusters << osb->s_clustersize_bits);
>> +
>> +	ret = ocfs2_journal_dirty(handle, main_bm_bh);
>> +	if (ret < 0) {
>> +		mlog_errno(ret);
>> +		goto out_unlock;
>> +	}
>> +
>> +	ret = ocfs2_commit_trans(osb, handle);
>> +	if (ret < 0) {
>> +		mlog_errno(ret);
>> +		goto out_unlock;
>> +	}
>> +
>> +	spin_lock(&OCFS2_I(main_bm_inode)->ip_lock);
>> +	OCFS2_I(main_bm_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
>> +	spin_unlock(&OCFS2_I(main_bm_inode)->ip_lock);
>>     
>
> Need to also update i_size. I think the other patch was missing
> that too...
> 	--Mark
>   
Sorry for the late response. I have been in leave for some days.
Do you mean "fe->i_size" which I have updated above?
If it is,  do I need to spin_lock and update "fe->i_size" and 
"ip_clusters" in the same time before commit_trans?
I saw some similar codes in suballoc.c.
