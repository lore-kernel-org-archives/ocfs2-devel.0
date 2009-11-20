From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Thu, 19 Nov 2009 23:57:25 -0800
Subject: [Ocfs2-devel] o2net patch that avoids socket disconnect/reconnect
Message-ID: <1258703846-23212-1-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This fix modifies o2net layer behavior which seems to trigger some
DLM race issues during umount/evictions that needs to be fixed as well.

I am working on the dlm issues but meanwhile please review this patch.

Thanks,
--Srini
