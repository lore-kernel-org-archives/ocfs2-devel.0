From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 26 Nov 2008 19:04:50 -0800
Subject: [Ocfs2-devel] [PATCH 09/13] ocfs2: Start using buckets
	in	ocfs2_adjust_xattr_cross_cluster().
In-Reply-To: <492E02E5.9080102@oracle.com>
References: <1227744386-10502-1-git-send-email-joel.becker@oracle.com>
	<1227744386-10502-10-git-send-email-joel.becker@oracle.com>
	<492E02E5.9080102@oracle.com>
Message-ID: <20081127030450.GE6259@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Nov 27, 2008 at 10:16:05AM +0800, Tao Ma wrote:
>> -		ret = ocfs2_read_xattr_bucket(new_first, src_blkno);
>> +		ret = ocfs2_read_xattr_bucket(new_first, new_blkno);
>>  		if (ret) {
>>  			mlog_errno(ret);
>>  			goto out;
> sorry, I didn't see you change it here, but it may be merged with the  
> previous patch.

	I did move it to the previous patch in my git tree.

Joel

-- 

Life's Little Instruction Book #356

	"Be there when people need you."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
