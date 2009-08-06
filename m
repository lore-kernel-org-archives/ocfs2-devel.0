From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu,  6 Aug 2009 16:12:57 -0700
Subject: [Ocfs2-devel] Non-sparse write fix -v4
Message-ID: <1249600378-18706-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

So the problem with the last patch was that it did not handle blocksize < pagesize.
On a x86 box, with a 2K/4K file system, it was only initializing the first 2K block.

This fixes it.

Sunil
