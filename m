From: Joseph Qi <joseph.qi@huawei.com>
Date: Tue, 28 Oct 2014 20:59:58 +0800
Subject: [Ocfs2-devel] [PATCH 0/7 v5] ocfs2: support append O_DIRECT write
Message-ID: <544F934E.4010303@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Currently in case of append O_DIRECT write (block not allocated yet),
ocfs2 will fall back to buffered I/O. This has some disadvantages.
Firstly, it is not the behavior as expected.
Secondly, it will consume huge page cache, e.g. in mass backup scenario.
Thirdly, modern filesystems such as ext4 support this feature.

In this patch set, the direct I/O write doesn't fallback to buffer I/O
write any more because the allocate blocks are enabled in direct I/O
now.

changelog:
v5 <- v4:
 -- take Andrew's advice of using do_div() instead of mod(%).
 -- using ocfs2_bytes_to_clusters instead of ocfs2_clusters_for_bytes,
    because we need the floor when calculate v_cpos, not roof.
 -- call __blockdev_direct_IO instead of blockdev_direct_IO in
    ocfs2_direct_IO_write to pass end_io function.
 -- do not override the return value of __blockdev_direct_IO.
 -- after calling generic_file_direct_write, *ppos is already changed,
    so do not change it again in ocfs2_file_write_iter.
 -- fix the issue when do append O_DIRECT write and unlink/rename
    concurrently.

Any feedback are always appreciated.
Thanks.
