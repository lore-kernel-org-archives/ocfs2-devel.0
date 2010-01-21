From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 21 Jan 2010 10:50:01 -0800
Subject: [Ocfs2-devel] dlmglue fixes
Message-ID: <1264099803-16680-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

David,

So here are the two patches. Remove all patches that you have and apply
these.

The first one is straight forward.

The second one will hopefully fix the livelock issue you have been
encountering.

People reviewing the patches should note that the second one is slightly
different than the one I posted earlier. It removes the BUG_ON in the if
condition where we jump to update_holders. The accompanying comment has
also been updated.

Thanks
Sunil
