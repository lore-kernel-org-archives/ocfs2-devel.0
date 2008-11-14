From: Andrew Beekhof <beekhof@gmail.com>
Date: Fri, 14 Nov 2008 12:34:43 +0100
Subject: [Ocfs2-devel] [Pacemaker] [RFC] Splitting cluster.git into
	separate projects/trees
In-Reply-To: <Pine.LNX.4.64.0811141055590.7841@trider-g7>
References: <1226654293.4022.56.camel@daitarn-fedora.int.fabbione.net>
	<26ef5e70811140150l7e789e8blc9df3de904a20a3c@mail.gmail.com>
	<Pine.LNX.4.64.0811141055590.7841@trider-g7>
Message-ID: <26ef5e70811140334n47618506u7a9cb11de1ca6adb@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Ooops, resending for the CC'd lists

On Fri, Nov 14, 2008 at 11:06, Fabio M. Di Nitto <fdinitto@redhat.com> wrote:
> On Fri, 14 Nov 2008, Andrew Beekhof wrote:
>
>> Top-posting...
>>
>> #1 is what the current "situation" evolved from so I think its pretty
>> clear that despite the best of intentions, it doesn't work out (far
>> too easy for cross-dependancies to develop).
>>
>> #2 - I share chrissie's feelings on this one ;-)
>>
>> #3 - Thats got my vote - basically what we did with Pacemaker.
>>
>> The biggest question here is do you want old versions of the split out
>> code to be buildable?
>
> I am not 100% sure I understand what you mean..

Perhaps an example from our split...

The Pacemaker repo includes the _entire_ Heartbeat history up until the split.
This allows me to build versions of the crm from before the split
(handy if you're doing "hg bisect" to track down which changeset broke
something).

On the other hand, I don't care about old versions of the GUI... so
the GUI repo only has the history of the files specific to the GUI.
This means that you can't build the pre-split versions from there
because the files that used to be in the same repo aren't there
anymore.

You can of course switch to the Heartbeat repo and build the old GUI
versions from there.

Am I making sense now?
