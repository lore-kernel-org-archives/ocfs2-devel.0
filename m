From: Matthew Huff <mhuff@ox.com>
Date: Tue, 12 Aug 2014 15:13:26 +0000
Subject: [Ocfs2-devel] [Ocfs2-users] Does any other company and
 production use the ocfs2?
In-Reply-To: <53E97568.3080805@huawei.com>
References: <53E97568.3080805@huawei.com>
Message-ID: <a083f033f76e4bc7872255393bda8f0c@pur-vm-exch13n2.ox.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We did.

We used it for our Oracle DB running on RHEL

But since Oracle stopped upgrading it except for Oracle Linux, we migrated to ext4 (we didn't need the cluster feature, just wanted the direct i/o), but ext4 is working fine for us now.

----
Matthew Huff???????????? | 1 Manhattanville Rd
Director of Operations?? | Purchase, NY 10577
OTA Management LLC??? ???| Phone: 914-460-4039

-----Original Message-----
From: ocfs2-users-bounces@oss.oracle.com [mailto:ocfs2-users-bounces at oss.oracle.com] On Behalf Of Jensen
Sent: Monday, August 11, 2014 10:01 PM
To: ocfs2-users at oss.oracle.com; ocfs2-devel at oss.oracle.com
Subject: [Ocfs2-users] Does any other company and production use the ocfs2?

Hi all,
     I want to know whether any other company and production use the ocfs2 ?

  Thanks.
  Jensen
 2014.8.12


_______________________________________________
Ocfs2-users mailing list
Ocfs2-users at oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-users
