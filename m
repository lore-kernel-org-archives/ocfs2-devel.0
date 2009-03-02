From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Mon, 02 Mar 2009 10:16:00 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: anti stale inode for nfs (V5)
In-Reply-To: <20090228022236.GK10695@mail.oracle.com>
References: <200902271234.n1RCYbZ2022526@rgminet15.oracle.com>
	<20090228022236.GK10695@mail.oracle.com>
Message-ID: <49AB4160.8050609@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

> 
>> +	bg_blkno = ocfs2_which_suballoc_group(blkno, bit);
>> +	status = ocfs2_read_group_descriptor(suballoc, alloc_fe, bg_blkno,
>> +					     &group_bh);
>> +	if (status < 0) {
>> +		mlog(ML_ERROR, "read group %llu failed %d\n", bg_blkno, status);
>> +		goto bail;
>> +	}
>> +
>> +	status = ocfs2_check_group_descriptor(osb->sb, alloc_fe, group_bh);
>> +	if (status < 0) {
>> +		mlog(ML_ERROR, "check group %llu faild %d\n", bg_blkno, status);
>> +		goto bail;
>> +	}
> 
> 	The call to ocfs2_read_group_descriptor() already does the same
> checkin as ocfs2_check_group_descriptor(), so you don't need to call
> ocfs2_check_group_descriptor().  

ah, yes.  I only verified that ocfs2_check_group_descriptor() is not 
called in ocfs2_read_group_descriptor(). but didn't notice the same 
contents are done in ocfs2_read_group_descriptor() as well.
will repost as V6.

> 	Other than that, I think this patch is done!  Do you have a test
> to test it?

I tested against V4 which checks group without sub allocator cluster 
lock taken.
the test case is:
1) 2 nodes env
2) each node exports ocfs2 fs(/wwg-ocfs2_test).
3) each node does the script:

OCFS2_TOP=/wwg-ocfs2-test
TOP_DIR=/ocfs2-export
write_thread()
{
         while [ 1 ] ; do
                 host=`/bin/hostname`
                 /bin/rm -rf $TOP_DIR/$host
                 /bin/mkdir $TOP_DIR/$host
                 /bin/cp -r /usr/share $TOP_DIR/$host/
         done
}

mkdir $OCFS2_TOP $TOP_DIR
mount -L ocfs2_anti_stale $OCFS2_TOP
mount -o nordirplus 127.0.0.1:/${OCFS2_TOP} ${TOP_DIR}
write_thread&
while [ 1 ]; do
         ls -lR $TOP_DIR >/dev/null 2>&1
done


is it enough?

regards,
wengang.
