From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Tue, 12 Nov 2013 08:06:04 -0600
Subject: [Ocfs2-devel] [PATCH 0/6] nocontrold: Eliminating ocfs2_controld v5
Message-ID: <20131112140559.GA3836@shrek.lan>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

This is an effort of removing ocfs2_controld.pcmk and getting ocfs2 DLM
handling up to the times with respect to DLM (>=4.0.1) and corosync
(2.3.x). AFAIK, cman also is being phased out for a unified corosync
cluster stack.

fs/dlm performs all the functions with respect to fencing and node
management and provides the API's to do so for ocfs2. For all future
references, DLM stands for fs/dlm code.

The advantages are:
 + No need to run an additional userspace daemon (ocfs2_controld)
 + No contrrold devince handling and controld protocol
 + Shifting responsibilities of node management to DLM layer

For backward compatibility, we are keeping the controld handling code. Once
enough time has passed we can remove a significant portion of the code. This
was tested by using the kernel with changes on older unmodified tools. The
kernel used ocfs2_controld as expected, and displayed the appropriate
warning message.

This feature requires modification in the userspace ocfs2-tools.
The changes can be found at:
https://github.com/goldwynr/ocfs2-tools branch: nocontrold
Currently, not many checks are present in the userspace code,
but that would change soon.

These changes were developed on linux-stable 3.11.y. However, the 
changes are applicable to the current upstream as well. If you wish
to give the entire kernel a spin, the link is:

https://github.com/goldwynr/linux-stable branch: nocontrold

Changes since v4:
* Mark Fasheh's review comments
* Removed some version sanity checks because of data structure used (Dan)

Changes since v3:
* Added version negotiation using DLM lock
* Used strlcpy() instead of memcpy()

Changes since v2:
* Joel's comments: patch re-factoring

Changes since v1:
* Backward compatibility with ocfs2_controld


-- 
Goldwyn
