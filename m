From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 08 Dec 2010 10:30:16 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: make existing convertion
 precedent over new lock
In-Reply-To: <20101208181222.GD21913@mail.oracle.com>
References: <201012081237.oB7Ibeoo012391@acsinet15.oracle.com>	<20101208180757.GC21913@mail.oracle.com>
	<20101208181222.GD21913@mail.oracle.com>
Message-ID: <4CFFCEB8.8000202@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 12/08/2010 10:12 AM, Joel Becker wrote:
> On Wed, Dec 08, 2010 at 10:07:57AM -0800, Joel Becker wrote:
>> On Wed, Dec 08, 2010 at 08:34:39PM +0800, Wengang Wang wrote:
>>> Make existing convertion precedent over new lock. It makes o2dlm locking more
>>> like fair locking.
>> 	Is this a problem you were solving, or just something you
>> thought about while reading the code?  If it was a problem you ran
>> into, can you give the details?
> 	It looks like you're just emulating the logic from
> __dlmconvert_master().  That makes sense.

This fix is an offshoot of the conversation in his thread.
http://oss.oracle.com/pipermail/ocfs2-devel/2010-November/007524.html

The fix looks ok. But I would rather that we confirm this problem and the
fix before we push it upstream.

Wengang, Have you attempted to reproduce the problem and/or test the fix?

Sunil
