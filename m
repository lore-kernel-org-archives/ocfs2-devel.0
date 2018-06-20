From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 20 Jun 2018 09:39:21 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2: dlmglue: clean up timestamp
	handling
In-Reply-To: <20180619215202.zniqq3py3hqjeudv@merlin>
References: <20180619155826.4106487-1-arnd@arndb.de>
	<20180619171407.yoncg72ed2vncf62@merlin>
	<CAK8P3a0Mcm+AxBPxouMZJKXfbEyX-UD3=_speEj7bsW9nmnjzA@mail.gmail.com>
	<20180619215202.zniqq3py3hqjeudv@merlin>
Message-ID: <CAK8P3a2CVxTioR0s9xX3T_q+wR6mxHXTyw1U5vWaPeabNQrR0Q@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, y2038 Mailman List <y2038@lists.linaro.org>, Eric Ren <zren@suse.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Deepa Dinamani <deepa.kernel@gmail.com>, ocfs2-devel@oss.oracle.com

On Tue, Jun 19, 2018 at 11:52 PM, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
> On 06-19 21:11, Arnd Bergmann wrote:
>> On Tue, Jun 19, 2018 at 7:14 PM, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
>> > On 06-19 17:58, Arnd Bergmann wrote:

>> Here, setting a timestamp before 1970 or after 2514 will get wrapped
>> around in unpatched kernels, but will be clamped to the minimum
>> and maximum times after the patch.
>>
>> It is extremely rare for correct code to need timestamps outside of that
>> range, but it is also trivial to trigger that with a manual 'touch' command
>> from user space.
>>
>> If the change is a problem, I can resend the patch without that one
>> line change.
>>
>
> I think you should keep the change, but incrment OCFS2_LVB_VERSION.

Won't that cause additional incompatibilities? I don't know how this
macro gets used, but normally we don't use version numbers in
kernel interfaces if that prevents us from using old user space code
with newer kernels.

      Arnd
