From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Wed, 3 Aug 2011 17:48:52 -0500
Subject: [Ocfs2-devel] [PATCH 0/3] Avoid EROFS in case of dx dir errors v2
Message-ID: <CAJtY7HXea72dciViNv6W-Es1g_Yv1Dv+FAHvxsAB80dwQN48uw@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In case of an error while reading a dx tree of a directory,
the filesystem turns read-only. The information to process the request
is present in the main directory structure and a read-only information
can be provided from there.

This patchset disables the index directory in case of an error, and
proceeds with the operation using the information in the main
directory structure. It prints the necessary errors in the kernel
messages for user to identify the corruption.

Changes vs v1:
        Incorporated Joel's comments. Despite being split into 3, this
patchset is smaller.

-- 
Goldwyn
