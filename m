From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Wed Jan 23 01:58:34 2008
Subject: [Ocfs2-devel] block-count in mkfs.ocfs2
Message-ID: <20080123095822.GB18317@baloo.nue.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

While making changes to mkfs, I noticed blocks-count is taken as a positional argument (value determined by the position in the command line) instead of an optional argument (parsed by getopts such as --block-count). Is there a particular reason for this?

Moreover, you might have to check on the default values of the mkfs_default_profile. Only the journal size in case of "datafiles" filesystem type seem to be having a default value of 8k.

Regards,

-- 
Goldwyn
