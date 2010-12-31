From: Nick Piggin <npiggin@gmail.com>
Date: Fri, 31 Dec 2010 11:51:30 -0000
Subject: [Ocfs2-devel] Confused by commit 56a76f [fs: fix page_mkwrite
 error cases in core code and btrfs]
In-Reply-To: <20101231113949.GA21179@mail.oracle.com>
References: <20101230232936.GA931@mail.oracle.com>
	<AANLkTi=afH_Qqb0wfn4UjXju__QjKKa+cBTS4tO5o2NJ@mail.gmail.com>
	<20101231110054.GA20521@mail.oracle.com>
	<AANLkTik3_=Jo2ubML1hhanFFKC3MkEibrCPruto2oY_v@mail.gmail.com>
	<20101231113949.GA21179@mail.oracle.com>
Message-ID: <AANLkTinpXuLQSm_W2xOrTXvn3TGGMuzvkMR1GMSwdxsM@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Fri, Dec 31, 2010 at 10:39 PM, Joel Becker <Joel.Becker@oracle.com> wrote:
> On Fri, Dec 31, 2010 at 10:16:35PM +1100, Nick Piggin wrote:
>> On Fri, Dec 31, 2010 at 10:00 PM, Joel Becker <jlbec@evilplan.org> wrote:
>> > On Fri, Dec 31, 2010 at 08:31:41PM +1100, Nick Piggin wrote:
>> >> On Fri, Dec 31, 2010 at 10:29 AM, Joel Becker <Joel.Becker@oracle.com> wrote:
>>
>> >> The better way to do this would be to just return VM_FAULT_NOPAGE
>> >> in any case you need the VM to retry the fault. When you reach the
>> >> business end of your handler, you want to hold the page locked, after
>> >> you verify it is correct, and return that to the fault handler.
>> >
>> > ? ? ? ?This is going to be hard. ?Our write_end() assumes it must
>> > unlock the pages (which is normal behavior for write(2)), but in the
>> > page_mkwrite() case we need to avoid the unlock to follow your
>> > recommendation (we use our write_begin/write_end pair to trigger any
>> > allocation or zeroing needed before the page is writable).
>>
>> Yes that would be the best option. It is possible to use the unlocked
>> return, but that still gives possibility of races in some cases. Consider
>
> ? ? ? ?Yes, I am aware of that.
>
>> Basically it would be nice for all filesystems to move to this convention
>> so we can remove the old cruft.
>
> ? ? ? ?I can appreciate that. ?And you've just answered the "Do you
> want us to get there, or are minor faults in the old-0-style OK?"
> question.

It is OK in that it will work. It is not preferred, if you are reworking pleaase
use the new style.


>> > ? ? ? ?The find_or_create_page() is deep at the meat of the function,
>> > not the cursory check at the top. ?The idea is that at this point,
>> > find_or_create_page() will return a locked page that must, by
>> > definition, be part of the correct mapping.
>>
>> But you must still handle failures there, because find_or_create_page
>> may return -ENOMEM. So just lock the page, recheck the mapping
>> there, and then do exactly the same error handling.
>
> ? ? ? ?Of course it can error, but error is different than clean
> restart. ?Though cleanup should be the same; I'm looking at our code
> trying to convince myself that this is so ;-)

Cleanup is exactly the same, yes, because the only difference in
different error codes is what the VM does with them.


> ?Btw, -ENOMEM is that OOM
> fault error, right? ;-)

Right.


>> > ? ? ? ?If the VM is rechecking the pte after we return from
>> > page_mkwrite(), won't it see any new page created?
>>
>> But the point of page_mkwrite is a dirty notifier for the fs. If this new
>> different page was installed due to say truncate then a read-only
>> fault, the filesystem would miss the notification. So it just does the
>> simple thing and retries the whole sequence (if needed).
>
> ? ? ? ?Fair enough, even if we caused the new page and thus are already
> notified ;-)

Well, you would be notified via ->fault, but not not writable fault and no
page_mkwrite.


> ? ? ? ?Essentially, you would really like us (and ext4, and gfs2, etc)
> to start returning VM_FAULT_NOPAGE for any place we aren't sure what
> happened to our page, VM_FAULT_OOM when we get an -ENOMEM, and
> VM_FAULT_LOCKED for all successful operations. ?That the long and short
> of it? ?Thank you for helping me understand your plan for this code.

Exactly.


> ? ? ? ?Btw, what not use VM_FAULT_RETRY for "I'd like you to retry"?
> Especially since the comment for NOPAGE doesn't read anything like its
> actual behavior.

It was designed first to replace that old ->nopfn handler, so it does need
comments updating. RETRY doesn't cover the ->nopfn usage, but NOPAGE
does cover the retry usage, I think, so names are OK.
