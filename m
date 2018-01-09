From: Changwei Ge <ge.changwei@h3c.com>
Date: Tue, 9 Jan 2018 01:49:23 +0000
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: make metadata estimation
	accurate and clear
References: <63ADC13FD55D6546B7DECE290D39E373F290CEEE@H3CMLB12-EX.srv.huawei-3com.com>
	<20180108172349.da537610c561ee7cfd6969e8@linux-foundation.org>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373F290DA5A@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Andrew

On 2018/1/9 9:24, Andrew Morton wrote:
> On Mon, 8 Jan 2018 01:36:05 +0000 Changwei Ge <ge.changwei@h3c.com> wrote:
> 
>> Current code assume that ::w_unwritten_list always has only one item on.
>> This is not right and hard to get understood.
>> So improve how to count unwritten item.
> 
> I get a large number of patch rejects applying this (and patch 2) to
> current mainline.  What kernel version are these against?
> 
> 

These two patches are against 4.15-rc4 (1291a0d5049dbc06baaaf66a9ff3f53db493b19b).
If you have any preferable kernel version, please let me know.

Thanks,
Changwei
