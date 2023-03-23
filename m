Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29C41C6FD1C
	for <ocfs2-devel@archiver.kernel.org>; Thu, 23 Mar 2023 23:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ZG6r9iHLIqkNkb/elhmn+nJryGSNxM35IILCTKo/aiM=;
 b=s4EwABU/iHaRz3XDxiFxk7OSO3CU/RyvlzMe3K7ihe+GoQ/XllYK06SkIs+PSsqpHm7PGCIWP2/q
   lfcSfuIY3bi9SA0AB3RyB8I7eDlO9UNUqy4o/NNNz8Rh7AZulVrhrfq+NoJItPUPnbZtzjgK/MZW
   bGk5OP+XFi/GxXvq6r+NUQhk02GJBwGO3eOkT30+VzhsILMa6+VHMyEuRj5sY83NuadTDQHETj2N
   6LyBORsCXaDixbuQpdKqfANCP/t53Cu+anRr2yUy+p7C+Hq6mp1/FwvF7K6O4lKdMev+AkLxLlGb
   rcbXLDFS6rjeXAptqSAHi8vLhwWpDhQeESO96Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ZG6r9iHLIqkNkb/elhmn+nJryGSNxM35IILCTKo/aiM=;
 b=r+OBtar6Inhtl7CnyjUAOf2Vx6a8/oT9n3BuDhsIpxdz2+U3JFtjyKTEjUk28+q+bTCfeJTga3Pd
   H/88TUj9pshS5UKe9ch+KDb37nY2ibMgr+zZDxpnetmm8AllyjdMf1b+tk1tsi9zGhyC4GwXYTm9
   DJ/9ftSb1OYmRi26/idtp6kLqa4QNkK9ICBEqJreRl5/8Eq69BGzRXWZfSQZKILRpHhs5W09haDA
   pR7bOiRHWccjzavd/g68+O7fHrWXAzMcL4sHHjQ0xKkX3K5x+9kjSGjs+PSmtq7Fb7qYldTB6+/1
   M/lQAFiRYtLdiwpsYRSrn9ykk8WZFNOU0lwk9g==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RRZ00BG5YYJBL00@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 23 Mar 2023 23:37:31 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=paul-moore.com;
 s=google; t=1679614638;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:from:to:cc:subject:date
 :message-id:reply-to; bh=H5DqnFNdwoRsvRD9gY7AVflhKHmqWJvLpG3CELYJwy4=;
 b=MvmzhjViCPcj6Nhc+3xUZBlHLNZc4r6lPParcd8U1SVaNbw7wKC7ctiSLNtETXsbZR
 SfRHOqCYRqd1uqAwWuo9yiMFLI0eaNDRiZlTA6cLo/WgAikQelZ1tHGFpIZZPWcjT35o
 RAn0baZ5sYIIGCdLt+R9DAyKHRnnJXL0EwkWhxKR9y3ewPQOPLqgHbZlIjayJV65Q4zv
 5Lw4K4PXz4x9XgSVjgC27sSASSJW5nHoZurlVklnEY9HZZJhC9oqu0bxuU17lvaxiU3a
 kl+1LdimUZ3SdVmvRmCVK2t7FT3bIF4MTO+fvC6g4axqIpSiLufJkJgHH86Rqinq42Ye nNDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; t=1679614638;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=H5DqnFNdwoRsvRD9gY7AVflhKHmqWJvLpG3CELYJwy4=;
 b=MjcSTLtzxw12Y//Bl2gVe3JtKQEoeFgu74EDSK/5ELcxylD+zh6ScjO0UmcOyCnAhk
 ThgDl57rCLkzS7nyc4jkOtSYNNPRygk/jMfhY2YzLRcVdah2BFRCRZiRYoPv/bXITMyG
 TaDRscNIO6ukAav/7z2TG5cmQEquBynO7uM19No+RFlZfod3MAjPJN3Dv3/y9LWWH2by
 M9JQqpnjvp5tnrl65+SVaadI7z8+VvfiQNmBFa8B182Yl+NhlS1gWP4AcN2H1LPNwPRO
 MjikhsLXGghDBEjgWMOOjZ8l8LVHFz1LwAv7UHHrrb09hB6Rr5tlbkYbdcOomVjniRxc deaA==
X-Gm-Message-State: AAQBX9crfRmkpTL96vNjKjbCU2YIHC8uAwAhACcJUjmK2hi5c0LWjLOW
 Rn+ra/BuN5wm98gz8lFjbx3TqOH9X92T3kDcRrbb
X-Received: by 2002:a05:6902:18c7:b0:b72:fff0:2f7f with SMTP id
 ck7-20020a05690218c700b00b72fff02f7fmr715296ybb.4.1679614638263; Thu,
 23 Mar 2023 16:37:18 -0700 (PDT)
MIME-version: 1.0
References: <20230314081720.4158676-1-roberto.sassu@huaweicloud.com>
 <20230314081720.4158676-3-roberto.sassu@huaweicloud.com>
In-reply-to: <20230314081720.4158676-3-roberto.sassu@huaweicloud.com>
Date: Thu, 23 Mar 2023 19:37:07 -0400
Message-id: <CAHC9VhSPMs6k4zm0rACiZZYuB84Avg9t+AnGBH4F+iiLsNgzkg@mail.gmail.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>
X-Source-IP: 209.85.219.181
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10658
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 mlxscore=0 lowpriorityscore=0 mlxlogscore=999 priorityscore=95 clxscore=131
 phishscore=0 malwarescore=0 spamscore=0 impostorscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303230171
Cc: nicolas.bouchinet@clip-os.org, linux-kernel@vger.kernel.org,
 keescook@chromium.org, selinux@vger.kernel.org, dmitry.kasatkin@gmail.com,
 Roberto Sassu <roberto.sassu@huawei.com>, jmorris@namei.org,
 zohar@linux.ibm.com, reiserfs-devel@vger.kernel.org,
 linux-security-module@vger.kernel.org, casey@schaufler-ca.com,
 eparis@parisplace.org, linux-integrity@vger.kernel.org,
 stephen.smalley.work@gmail.com, ocfs2-devel@oss.oracle.com, serge@hallyn.com
Subject: Re: [Ocfs2-devel] [PATCH v8 2/6] ocfs2: Switch to
	security_inode_init_security()
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Paul Moore via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Paul Moore <paul@paul-moore.com>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 AKy350aKUo52lrEIhVqCcrwLfuJGssfxNEL6IV2NSjb63kt7Z52L3fpiOf67Jiyy9HPq6D2tt3ioTIkNycC6sWUe3fE=
X-ServerName: mail-yb1-f181.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 1mBwZfe2UXjvzkAEJgdXdCONz1hZHY_-
X-Proofpoint-GUID: 1mBwZfe2UXjvzkAEJgdXdCONz1hZHY_-
Reporting-Meta:
 AAHfHcD351eAF9LzGDxeAIUswspsxs8tX6UQyPxFk6Dv3Js2soPX2I8hn5y8ZSV0
 lBxfnZ88ymMlFj9XsPSJyXlbXg1FrFdoHAu9/IdkyA+qgiCKxwjyFEgGa9As0X6r
 jPqZDGpLCgUUPMiTxuJoQe4venfYg66NBavv8Nka2ziEgHKtT+NxXhGhmofGBXNW
 FJMGJEFOhHudFNwEtNdYUogsyLIOeq/hWAtw412AhWuAzphv6GIXYyL5PyO7eLGJ
 GeFYzJvxE3mS6+foVz7MSbN3ed80ehsSdIhqIo54a9wQO24ZzSaIQH4zfKs3hQug
 q1lK61+510MWguEMR363eiZqp3aRCv8TMu/UBmfCkW+QwsRazw4wlBUV2IWFT3nK
 DjrM5eE8zDxPhnfBi8q4hxqdVxRVci+X7wOnnRaVwvPF96iEKUSXoSbSnKj+h8+d
 ltsrpyqCPZdeND37n817xOHioxkiwjAPJhmNeYPhockUHouFbQbYGnMjxA3uADax
 FDCszLdWbKvi3wZDZUUOTZRiQLxvNE2higMJw0qsETew

T24gVHVlLCBNYXIgMTQsIDIwMjMgYXQgNDoxOOKAr0FNIFJvYmVydG8gU2Fzc3UKPHJvYmVydG8u
c2Fzc3VAaHVhd2VpY2xvdWQuY29tPiB3cm90ZToKPgo+IEZyb206IFJvYmVydG8gU2Fzc3UgPHJv
YmVydG8uc2Fzc3VAaHVhd2VpLmNvbT4KPgo+IEluIHByZXBhcmF0aW9uIGZvciByZW1vdmluZyBz
ZWN1cml0eV9vbGRfaW5vZGVfaW5pdF9zZWN1cml0eSgpLCBzd2l0Y2ggdG8KPiBzZWN1cml0eV9p
bm9kZV9pbml0X3NlY3VyaXR5KCkuCj4KPiBFeHRlbmQgdGhlIGV4aXN0aW5nIG9jZnMyX2luaXR4
YXR0cnMoKSB0byB0YWtlIHRoZQo+IG9jZnMyX3NlY3VyaXR5X3hhdHRyX2luZm8gc3RydWN0dXJl
IGZyb20gZnNfaW5mbywgYW5kIHBvcHVsYXRlIHRoZQo+IG5hbWUvdmFsdWUvbGVuIHRyaXBsZSB3
aXRoIHRoZSBmaXJzdCB4YXR0ciBwcm92aWRlZCBieSBMU01zLgo+Cj4gQXMgZnNfaW5mbyB3YXMg
bm90IHVzZWQgYmVmb3JlLCBvY2ZzMl9pbml0eGF0dHJzKCkgY2FuIG5vdyBoYW5kbGUgdGhlIGNh
c2UKPiBvZiByZXBsaWNhdGluZyB0aGUgYmVoYXZpb3Igb2Ygc2VjdXJpdHlfb2xkX2lub2RlX2lu
aXRfc2VjdXJpdHkoKSwgaS5lLgo+IGp1c3Qgb2J0YWluaW5nIHRoZSB4YXR0ciwgaW4gYWRkaXRp
b24gdG8gc2V0dGluZyBhbGwgeGF0dHJzIHByb3ZpZGVkIGJ5Cj4gTFNNcy4KPgo+IFN1cHBvcnRp
bmcgbXVsdGlwbGUgeGF0dHJzIGlzIG5vdCBjdXJyZW50bHkgc3VwcG9ydGVkIHdoZXJlCj4gc2Vj
dXJpdHlfb2xkX2lub2RlX2luaXRfc2VjdXJpdHkoKSB3YXMgY2FsbGVkIChta25vZCwgc3ltbGlu
ayksIGFzIGl0Cj4gcmVxdWlyZXMgbm9uLXRyaXZpYWwgY2hhbmdlcyB0aGF0IGNhbiBiZSBkb25l
IGF0IGEgbGF0ZXIgdGltZS4gTGlrZSBmb3IKPiByZWlzZXJmcywgZXZlbiBpZiBFVk0gaXMgaW52
b2tlZCwgaXQgd2lsbCBub3QgcHJvdmlkZSBhbiB4YXR0ciAoaWYgaXQgaXMKPiBub3QgdGhlIGZp
cnN0IHRvIHNldCBpdCwgaXRzIHhhdHRyIHdpbGwgYmUgZGlzY2FyZGVkOyBpZiBpdCBpcyB0aGUg
Zmlyc3QsCj4gaXQgZG9lcyBub3QgaGF2ZSB4YXR0cnMgdG8gY2FsY3VsYXRlIHRoZSBITUFDIG9u
KS4KPgo+IEZpbmFsbHksIHNpbmNlIHNlY3VyaXR5X2lub2RlX2luaXRfc2VjdXJpdHkoKSwgdW5s
aWtlCj4gc2VjdXJpdHlfb2xkX2lub2RlX2luaXRfc2VjdXJpdHkoKSwgcmV0dXJucyB6ZXJvIGlu
c3RlYWQgb2YgLUVPUE5PVFNVUFAgaWYKPiBubyB4YXR0cnMgd2VyZSBwcm92aWRlZCBieSBMU01z
IG9yIGlmIGlub2RlcyBhcmUgcHJpdmF0ZSwgYWRkaXRpb25hbGx5Cj4gY2hlY2sgaW4gb2NmczJf
aW5pdF9zZWN1cml0eV9nZXQoKSBpZiB0aGUgeGF0dHIgbmFtZSBpcyBzZXQuCj4KPiBJZiBub3Qs
IGFjdCBhcyBpZiBzZWN1cml0eV9vbGRfaW5vZGVfaW5pdF9zZWN1cml0eSgpIHJldHVybmVkIC1F
T1BOT1RTVVBQLAo+IGFuZCBzZXQgc2ktPmVuYWJsZSB0byB6ZXJvIHRvIG5vdGlmeSB0byB0aGUg
ZnVuY3Rpb25zIGZvbGxvd2luZwo+IG9jZnMyX2luaXRfc2VjdXJpdHlfZ2V0KCkgdGhhdCBubyB4
YXR0cnMgYXJlIGF2YWlsYWJsZS4KPgo+IFNpZ25lZC1vZmYtYnk6IFJvYmVydG8gU2Fzc3UgPHJv
YmVydG8uc2Fzc3VAaHVhd2VpLmNvbT4KPiBSZXZpZXdlZC1ieTogQ2FzZXkgU2NoYXVmbGVyIDxj
YXNleUBzY2hhdWZsZXItY2EuY29tPgo+IEFja2VkLWJ5OiBKb3NlcGggUWkgPGpvc2VwaC5xaUBs
aW51eC5hbGliYWJhLmNvbT4KPiAtLS0KPiAgZnMvb2NmczIvbmFtZWkuYyB8ICAyICsrCj4gIGZz
L29jZnMyL3hhdHRyLmMgfCAzMCArKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0KPiAgMiBm
aWxlcyBjaGFuZ2VkLCAyOCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQoKTWVyZ2VkIGlu
dG8gbHNtL25leHQsIHRoYW5rcy4KCi0tIApwYXVsLW1vb3JlLmNvbQoKX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0
Ck9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1h
bi9saXN0aW5mby9vY2ZzMi1kZXZlbA==
