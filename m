From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 26 Nov 2008 19:03:30 -0800
Subject: [Ocfs2-devel] [PATCH 08/13] ocfs2: Use ocfs2_mv_xattr_buckets()
	in	ocfs2_mv_xattr_bucket_cross_cluster().
In-Reply-To: <492E019E.5090308@oracle.com>
References: <1227744386-10502-1-git-send-email-joel.becker@oracle.com>
	<1227744386-10502-9-git-send-email-joel.becker@oracle.com>
	<492E019E.5090308@oracle.com>
Message-ID: <20081127030330.GD6259@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Nov 27, 2008 at 10:10:38AM +0800, Tao Ma wrote:
> Joel Becker wrote:
>> Now that ocfs2_mv_xattr_buckets() can move a partial cluster's worth of
>> buckets, ocfs2_mv_xattr_bucket_cross_cluster() can use it.

<snip>

>> -		ret = ocfs2_read_xattr_bucket(old_first, src_blkno);
>> +		ret = ocfs2_read_xattr_bucket(new_first, src_blkno);
>> +		if (ret) {
>> +			mlog_errno(ret);
>> +			goto out;
>> +		}
> here should read new_blkno since "new_first" means the first bucket of  
> the new cluster(I guess that from the code you removed).

	I was hoping you'd notice that :-)  I saw it when reviewing
the emailed patches, and I've already fixed it in my git tree.

Joel

-- 

"People with narrow minds usually have broad tongues."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
