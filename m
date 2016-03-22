From: Gang He <ghe@suse.com>
Date: Mon, 21 Mar 2016 20:15:34 -0600
Subject: [Ocfs2-devel] [PATCH v4 2/5] ocfs2: sysfile interfaces for
 online file check
In-Reply-To: <20160321180101.60c8ff3b.akpm@linux-foundation.org>
References: <1456723082-13838-1-git-send-email-ghe@suse.com>
	<1456723082-13838-3-git-send-email-ghe@suse.com>
	<20160321225723.GF15881@wotan.suse.de>
	<20160321160547.ae1761d58b1728b964966f9f@linux-foundation.org>
	<20160321233802.GG15881@wotan.suse.de>
	<20160321180101.60c8ff3b.akpm@linux-foundation.org>
Message-ID: <56F11B46020000F90002EADF@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org, Mark Fasheh <mfasheh@suse.de>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Hello Mark and Andrew,

Thank for taking the time in reviewing the patches, move the thing forward.


Thanks
Gang




>>> 
> On Mon, 21 Mar 2016 16:38:02 -0700 Mark Fasheh <mfasheh@suse.de> wrote:
> 
>> On Mon, Mar 21, 2016 at 04:05:47PM -0700, Andrew Morton wrote:
>> > On Mon, 21 Mar 2016 15:57:23 -0700 Mark Fasheh <mfasheh@suse.de> wrote:
>> > 
>> > > On Mon, Feb 29, 2016 at 01:17:59PM +0800, Gang He wrote:
>> > > > Implement online file check sysfile interfaces, e.g.
>> > > > how to create the related sysfile according to device name,
>> > > > how to display/handle file check request from the sysfile.
>> > > > 
>> > > > Signed-off-by: Gang He <ghe@suse.com>
>> > > Reviewed-by: Mark Fasheh <mfasheh@suse.de>
>> > 
>> > Thanks.  So all of
>> > 
>> > ocfs2-export-ocfs2_kset-for-online-file-check.patch
>> > ocfs2-sysfile-interfaces-for-online-file-check.patch
>> > ocfs2-sysfile-interfaces-for-online-file-check-v4.patch
>> > ocfs2-create-remove-sysfile-for-online-file-check.patch
>> > ocfs2-check-fix-inode-block-for-online-file-check.patch
>> > ocfs2-check-fix-inode-block-for-online-file-check-v4.patch
>> > ocfs2-add-feature-document-for-online-file-check.patch
>> > 
>> > have your reviewed-by.  I'll send them on to Linus.
>> 
>> I'm curious, are the '-V4' patches built on top of the non '-V4' versions?
> 
> yes, the -v4 patches bring the base patch from
> whatever-version-i-originally-merged up to v4.
> 
>> Otherwise though this generally sounds good to me - I have reviewed the
>> entire online fsck patch series.
> 
> Cool.
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com 
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
