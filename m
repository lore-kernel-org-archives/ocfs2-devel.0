Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 070FBC54EAA
	for <ocfs2-devel@archiver.kernel.org>; Wed, 25 Jan 2023 17:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=a3zz01Q+S3/IH9UV6igGTT0nLCIumPotnpownanZK1I=;
 b=hTKfq6Arck9MQ93nObTiaBzsBAgmNo3VVV9Y7fpdLgailAxR7KwAHWWmF7AecmA1rCrKNL/6ARWs
   7vTbLvjDOH9hhVyxOHxtHvOvlgD8gDwpvGR3JJ+93QFzZdgUYaEe/bybc6YMnYC+3JXcBIgfAFSP
   Hwgta+FbGjvScMMXHohiK++cXL9OLGJytwH4IBNbQoB7S5yLLrKZUc+e7RKXj3NOpq6k+MG5bccw
   KPz/y5+n3BDURVxJO0pEWlCEwcg+YlgJ9TKibxRspimDliya10t44kWn1dG5MErmalmyuEeUoSdd
   USGdInDPUXytNCjHqhjpPjrpSHIosWGUoJQHsw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=a3zz01Q+S3/IH9UV6igGTT0nLCIumPotnpownanZK1I=;
 b=OcmS6Sil13/BH7fdvCJolGHgLIS/QXAKA8dQWn+Dk8kUPpDZXzXV8LaaRsAD6oxeB7VqWYoIs0C+
   94OVodjggp/QaTVZAjaw6VzIGZI56KfCTbW4HJjFVqW9kd7ysDGg97sgfGqjdqHJIHDOAm6bnLaW
   T6o/3wDv0YPV3hbw1ZDk+FpvvPMAqdsYFz0wuonZFwTfjPORpwH+nkzbFU6/LowbcBZrAlJuPNl8
   BzCGIUlbwrmPrUqL7gkUt75K2IXeV2FP8wKj/SSCe5BKnZwxl5Kc7jgfPviV7M8+J7H9zrZH3FMB
   WmnKCxl5kzRlPL+oOaLRXDfezU8eaMbdKBXo0g==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230118 64bit (built Jan 18
 2023))
 with ESMTPS id <0RP100OBUY0SOJ50@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 25 Jan 2023 17:31:40 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1674646165; bh=iVepgeT7psmWqr/2L8LpCH4RngFmQJ2i/zddXU3Ybms=;
 h=From:Subject:Date:To:Cc:From;
 b=aa0adWk8JIHYbDKjUCphZ1mzhrcTx2e5m+zTBZn9obQWuMBhYiKhvxE/PfkC0DrMo
 n+Ti2ja6VfjxgUnPOpsi1+/EmtHqmyra/AonZ5w9wjQlfzKpsP+4TOI050CJaL0N1y
 bKz7YhLgOmOvqok9PjXvsoVl3tKqVYUbksPXEapn+w0KefS9YB16xUcTypEO9pAwIN
 evQ3wG1KZlyA608u+IFmR08EX1UGoUJze8vveYRXvWqAxEv1eQ5rc5zD6Fc879yXFq
 13JMMXTEhD0lFVC6szsgPPomAG4klotXLnPAg8gEVmP0MH1tcrAZMyEp+bDrceHz66
 q2f2/uwZQY7jw==
Date: Wed, 25 Jan 2023 12:28:45 +0100
Message-id:
 <20230125-fs-acl-remove-generic-xattr-handlers-v1-0-6cf155b492b6@kernel.org>
MIME-version: 1.0
To: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
X-Mailer: b4 0.12.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10600
 signatures=596816
Cc: "Christian Brauner \(Microsoft\)" <brauner@kernel.org>,
 reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-mtd@lists.infradead.org, Al Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, ocfs2-devel@oss.oracle.com,
 Seth Forshee <sforshee@kernel.org>
Subject: [Ocfs2-devel] [PATCH 00/12] acl: remove remaining posix acl handlers
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Christian Brauner via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Christian Brauner <brauner@kernel.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-B4-Tracking: v=1; b=H4sIAG4S0WMC/x2O0QqDMBAEf0XuuSeaVgj9ldKHmGw0YGO5UxHEf
 2/s47DMsAcpJEHpWR0k2JKmORdobxX50eUBnEJhMo25N63pOCo7P7HgM2/gAbn4nne3LMJFCBN
 E+eEjgu06G6ylkuqdgntx2Y9XLGodV0VdQtf6FcS0/0+83uf5A07KJIqUAAAA
X-Developer-Signature: v=1; a=openpgp-sha256; l=3964; i=brauner@kernel.org;
 h=from:subject:message-id; bh=iVepgeT7psmWqr/2L8LpCH4RngFmQJ2i/zddXU3Ybms=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSRfFJq42SCo7mej0syzO7/VS69Ps21sFO48f9znuHr/fZEX
 p52lO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACYSeIbhn+X/3zmPrKtsko21fh3Smv
 5k/WvP2Uo6Sw92TuXesanV+BYjw7wCO68bLxsFprMsyP59RaXIcbL7hMBFnntnmxRL2pSJsAIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-GUID: Vce2prEIQwdPBEzXSr8lN1LEfmlYUyqT
X-Proofpoint-ORIG-GUID: Vce2prEIQwdPBEzXSr8lN1LEfmlYUyqT
Reporting-Meta:
 AAHpfjpDTVpEunyse4wkUE+6ragxPR0f/u6sILtb259DrvN2CfyOU2GUp4HFytt7
 iFRxG5ZG+yjd4p3Hf1c1kYiv2shrsavIONF4Thaczc6W1Dfv6fqR7MU687sM8yvP
 vcYsO6q3AiSrjjHKkK4lQcwE1cu1xLTWgiZvK4m3Xen2138LdYu3xIrF5Ksqk7fX
 tQpctK+VDTp4V2DVJ5pBVRpz61J++0glSVKJkZQs/S09SZlkN1eRpEQqGHvpJGhK
 h25OqaKkTZioV5w5FCpWEbj5G/JcMXTMDxmrmy5vJSE51XEUWueqP4GDWVAgr42p
 14Fdk+SZ8mkPb/65tdGa4qgUT888POZXWXNg8lFOpC0elMJ+M2K2cVKZ562uUsfD
 AHJtWTyqPxm64DsxDYjeMt3dVoVCx8LDwdYsXJXKy34e221XZt2QtX1S3XgTQ6QX
 J9cJMDs9aQp9UiZ3WjuItuAUH0h5OM4XqfDHU/WmVYPEU2EwH1gmqbOJaapDdkEJ
 UXR2Cm8gJELqyG3c4Fb9D11DWX3lvPyC4jqsny5vf9Xg

Hey everyone,

after we finished the introduction of the new posix acl api last cycle
we still left the generic POSIX ACL xattr handler around for two
reasons. First, because a few filesystems relied on the ->list() method
of the generic POSIX ACL xattr handlers in their ->listxattr() inode
operation. Second, during inode initalization in inode_init_always() the
registered xattr handlers in sb->s_xattr are used to raise IOP_XATTR in
inode->i_opflags.

With the removal of the legacy POSIX ACL handlers it is at least
possible for a filesystem to only implement POSIX ACLs but no other
xattrs. If that were to happen we would miss to raise IOP_XATTR because
sb->s_xattr would be NULL.

Fix these things and then get rid of the misleading and effectively
already unused generic POSIX ACL handlers.

For most filesystems it is a trivial removal of the generic POSIX ACL
handlers. Only for erofs, ext2, ext4, f2fs, jffs2, reiserfs, oc2fs the
handler is used but rather easy to fix.

All filesystems with reasonable integration into xfstests have been
tested with:

        ./check -g acl,attr,cap,idmapped,io_uring,perms,unlink

All tests pass without regression on xfstests for-next branch.

Since erofs doesn't have integration into xfstests yet afaict I have
tested it with the testuite available in erofs-utils. They also all pass
without any regressions.

This branch depends on [1] which hopefully should be merged soon and can
be pulled from [2] which already includes [1] so it's easy to test and
compile.

With this all remnants of the old POSIX ACL xattr handling will be gone.

Thanks!
Christian

[1]: https://lore.kernel.org/lkml/20230125100040.374709-1-brauner@kernel.org
[2]: ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/vfs/idmapping.git tags/fs.acl.remove.generic.xattr.handlers.v1

Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
Christian Brauner (12):
      xattr: simplify listxattr helpers
      xattr, posix acl: add listxattr helpers
      xattr: remove unused argument
      fs: drop unused posix acl handlers
      erofs: drop posix acl handlers
      ext2: drop posix acl handlers
      ext4: drop posix acl handlers
      f2fs: drop posix acl handlers
      jffs2: drop posix acl handlers
      ocfs2: drop posix acl handlers
      reiserfs: drop posix acl handlers
      acl: remove posix acl handlers

 fs/9p/xattr.c                   |   4 --
 fs/btrfs/xattr.c                |   4 --
 fs/ceph/xattr.c                 |   4 --
 fs/cifs/xattr.c                 |   4 --
 fs/ecryptfs/inode.c             |   4 --
 fs/erofs/xattr.c                |  49 ++++++++++++----
 fs/erofs/xattr.h                |  21 -------
 fs/ext2/xattr.c                 |  60 +++++++++++--------
 fs/ext4/xattr.c                 |  71 +++++++++++++----------
 fs/f2fs/xattr.c                 |  63 ++++++++++++--------
 fs/gfs2/xattr.c                 |   2 -
 fs/jffs2/xattr.c                |  42 +++++++-------
 fs/jfs/xattr.c                  |   4 --
 fs/nfs/nfs3_fs.h                |   1 -
 fs/nfs/nfs3acl.c                |   6 --
 fs/nfs/nfs3super.c              |   3 -
 fs/nfsd/nfs4xdr.c               |   3 +-
 fs/ntfs3/xattr.c                |   4 --
 fs/ocfs2/xattr.c                |  41 +++++++------
 fs/orangefs/xattr.c             |   2 -
 fs/overlayfs/super.c            |   8 ---
 fs/posix_acl.c                  |  20 -------
 fs/reiserfs/xattr.c             |  38 ++++++------
 fs/xattr.c                      | 124 ++++++++++++++++++++--------------------
 fs/xfs/xfs_xattr.c              |   4 --
 include/linux/posix_acl_xattr.h |   6 +-
 include/linux/xattr.h           |   8 ++-
 mm/shmem.c                      |   4 --
 28 files changed, 290 insertions(+), 314 deletions(-)
---
base-commit: 1b929c02afd37871d5afb9d498426f83432e71c2
change-id: 20230125-fs-acl-remove-generic-xattr-handlers-4cfed8558d88


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
