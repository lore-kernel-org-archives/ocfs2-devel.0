From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Fri Jan 25 10:25:11 2008
Subject: [Ocfs2-devel] block-count in mkfs.ocfs2
In-Reply-To: <20080123095822.GB18317@baloo.nue.novell.com>
References: <20080123095822.GB18317@baloo.nue.novell.com>
Message-ID: <479A295C.4020401@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

No reason other than mke2fs does the same. Using similar params makes
it easier for everyone. Also, we hardly expect anyone to limit the fs
to smaller than the volume size. AFAIK, it's mainly used in testing
(on/off)line fs resize. :)

It's 8k blocks... meaning 32M, for a 4K blocksize. That is fine if all
the user is doing is hosting datafiles as the db rarely grows the
datafiles... meaning no need for journaling.

Goldwyn Rodrigues wrote:
> Hi,
>
> While making changes to mkfs, I noticed blocks-count is taken as a positional argument (value determined by the position in the command line) instead of an optional argument (parsed by getopts such as --block-count). Is there a particular reason for this?
>
> Moreover, you might have to check on the default values of the mkfs_default_profile. Only the journal size in case of "datafiles" filesystem type seem to be having a default value of 8k.
>
> Regards,
>
>   
