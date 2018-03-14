From: Shichangkuo <shi.changkuo@h3c.com>
Date: Wed, 14 Mar 2018 10:13:00 +0000
Subject: [Ocfs2-devel]  Two questions about ocfs2_extent_map_insert_rec
Message-ID: <D1E4D02760513D4B90DC3B40FF32AF35E22F3EC6@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi All,
    When the extent_rec cannot be merged, we allocate a new item and add it into the em_list, then set it to NULL.
    It looks strange, and may cause null pointer exception if we access it again.
    Another doubt is the ip_lock was unlocked before allocating and was re-locked before searching again, does it necessary?
    I have no idea about the initial purpose and also don't know how to test it if I changed the code.
    Does someone help me?

Thanks.
Changkuo
-------------------------------------------------------------------------------------------------------------------------------------
?????????????????????????????????????
????????????????????????????????????????
????????????????????????????????????????
???
This e-mail and its attachments contain confidential information from New H3C, which is
intended only for the person or entity whose address is listed above. Any use of the
information contained herein in any way (including, but not limited to, total or partial
disclosure, reproduction, or dissemination) by persons other than the intended
recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
by phone or email immediately and delete it!
