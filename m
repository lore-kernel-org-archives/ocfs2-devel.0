From: Tiger Yang <tiger.yang@oracle.com>
Date: Mon, 15 Mar 2010 14:09:58 +0800
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2-1.6: add splice read/write
	support
In-Reply-To: <4B9A071A.3030706@oracle.com>
References: <1268384742-3861-1-git-send-email-tiger.yang@oracle.com>
	<1268384856-3929-1-git-send-email-tiger.yang@oracle.com>
	<4B9A071A.3030706@oracle.com>
Message-ID: <4B9DCF36.3020906@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Tao Ma wrote:
>> +void pipe_wait(struct pipe_inode_info *pipe)
> I just see that el5 already has splice support, see 
> http://www.redhat.com/rhel/features/
> 
> So we still need to copy these functions back? At least in el5u2, I see 
> these functions like pipe_wait, pipe_to_file etc.

Yes. We need copy these functions because they are not exported by the 
kernel of el5.

Because the struct splice_desc has been changed since 2.6.30, it it 
difficult to back port the latest code in mainline. So I chose the 
splice code in 2.6.29 for back porting. I hope the latest code before 
change are more stable and efficient.

thanks,
tiger
