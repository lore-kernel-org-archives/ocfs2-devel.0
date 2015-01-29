From: Changlimin <changlimin@h3c.com>
Date: Thu, 29 Jan 2015 01:02:27 +0000
Subject: [Ocfs2-devel] When fstrim, ocfs2_trim_group beyond end of device.
Message-ID: <BC29A004BA570342A4CC0044A384557268C41A26@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi?
         In Linux 3.18 kenrel, when fstrim a ocfs2 file system, fstrim shows IO error. Some logs in syslog:
                   attempt to access beyond end of device
                   sdb: rw=129, want=8390656, limit=8388608
                   (fstrim,36298,6):ocfs2_trim_group:7274 ERROR: status = -5
                   (fstrim,36298,6):ocfs2_trim_fs:7374 ERROR: status = -5

         In ocfs2_trim_group, next shoud compare with ip_clusters before call ocfs2_trim_extent.
         while (start < max) {
                   start = ocfs2_find_next_zero_bit(bitmap, max, start);
                   if (start >= max)
                            break;
                   next = ocfs2_find_next_bit(bitmap, max, start);

        /* next should compare with ip_clusters, ensure within device. But how to get ip_clusters here? Should pass inode from the caller? */
                   if (next > ip_clusters)
                            next = ip_clusters;

                   if (next > start && (next - start) >= minbits) {
                            ret = ocfs2_trim_extent(sb, gd,
                                                        start, next - start);
                            if (ret < 0) {
                                     mlog_errno(ret);
                                     break;
                            }
                            count += next - start;
                   }

Regards,
Changlimin
-------------------------------------------------------------------------------------------------------------------------------------
????????????????????????????????????????
????????????????????????????????????????
????????????????????????????????????????
???
This e-mail and its attachments contain confidential information from H3C, which is
intended only for the person or entity whose address is listed above. Any use of the
information contained herein in any way (including, but not limited to, total or partial
disclosure, reproduction, or dissemination) by persons other than the intended
recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
by phone or email immediately and delete it!
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20150129/cdf506f6/attachment-0001.html 
