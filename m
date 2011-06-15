From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Wed, 15 Jun 2011 10:57:23 -0500
Subject: [Ocfs2-devel] [PATCH 0/2] Avoid read-only filesystem on dx
	corruptions
Message-ID: <BANLkTinUr+59NAfedutNR05gsnKj8j3n5g@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In case of an error while reading a dx tree of a directory,
the filesystem turns read-only. The information to process the request
is present in the main directory structure.

This patchset disables the index directory in case of an error, and
proceeds with the operation using the information in the main
directory structure. It prints the necessary errors in the kernel
messages for user to identify the corruption.

TODO: Modify fsck.ocfs2 to create index for a directory large enough for an
index when it is not enabled.

-- 
Goldwyn
