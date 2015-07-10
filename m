From: Gang He <ghe@suse.com>
Date: Fri, 10 Jul 2015 01:26:56 -0600
Subject: [Ocfs2-devel] [PATCH 0/4] ocfs2: add online file check feature
In-Reply-To: <20150709140602.eafbc5a3b7660a6c7588e1b6@linux-foundation.org>
References: <1435123461-3525-1-git-send-email-ghe@suse.com>
	<20150709140602.eafbc5a3b7660a6c7588e1b6@linux-foundation.org>
Message-ID: <559FE440020000F90000E699@relay2.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org
Cc: ocfs2-devel@oss.oracle.com, Mark Fasheh <MFasheh@suse.com>, rgoldwyn@suse.de, linux-kernel@vger.kernel.org

Hi Andrew,

Thank for your suggestions.
I will sort out a document for ocfs2 online file check feature.


Thanks
Gang


>>> 
> On Wed, 24 Jun 2015 13:24:17 +0800 Gang He <ghe@suse.com> wrote:
> 
>> When there are errors in the ocfs2 filesystem,
>> they are usually accompanied by the inode number which caused the error.
>> This inode number would be the input to fixing the file.
>> One of these options could be considered:
>> A file in the sys filesytem which would accept inode numbers.
>> This could be used to communication back what has to be fixed or is fixed.
>> You could write:
>> $# echo "CHECK <inode>" > /sys/fs/ocfs2/devname/filecheck
>> or
>> $# echo "FIX <inode>" > /sys/fs/ocfs2/devname/filecheck
> 
> This is a userspace feature so it should have user documentation. 
> Documentation/filesystems/ocfs2.txt is presumably the appropriate
> place.
> 
> And the availability of the complete user documentation will make the
> review of this patchset more productive.
