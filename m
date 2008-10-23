From: Tiger Yang <tiger.yang@oracle.com>
Date: Thu, 23 Oct 2008 16:26:12 +0800
Subject: [Ocfs2-devel] ocfs2: some xattr fixes
Message-ID: <49003524.3090405@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Makr, Joel,

There are 4 fixes for xattr. The top 3 patches in the first patch of acl 
v3 patches before. The fourth patch is a new fix due to I met a bug 
about this.

1. fix licence in xattr
2. fix function declaration in xattr
3. remove duplicate definition in xattr
4. add array bounds checking

Best regards,
tiger
