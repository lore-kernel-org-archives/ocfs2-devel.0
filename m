Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FA11C7EE24
	for <ocfs2-devel@archiver.kernel.org>; Wed, 22 Mar 2023 17:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=H5UBcXff6bEK1GS7HMQQSVLyaJoRPDat0SY2/ngSMh0=;
 b=0jYc590Il/FXdWzOWhm2x4tU3f+Ea6u2Sde810AeQXVkfg98KXqCpUCxXgG8Daj8MonFGWyaCmNo
   SOMvkQ6anVpaxJ2CcIkSvZjF3sp82nwcuaH+cUePTb9/1DuKS/rkHVVWnCjjWin3N0Ec2BIjCjqi
   i2bvlBsU//e4lp0otUrIDylT9ApiOMVFcN7qYUCyvvb0Fk04WGAChjeOBNINBr718h3pGMp/nG0X
   hSWfOHsZibyd9oXA6zbuqxoy9APRrtEITo1XNR7jBqqRIs02aJ/zg11/Bhj40LONoOp+i9bqBYCk
   r1IHDaPCRhqMM62L29mJYhl19WHL7TmxIpA/7Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=H5UBcXff6bEK1GS7HMQQSVLyaJoRPDat0SY2/ngSMh0=;
 b=evNswES4aBZS7sPbivqud3WHlAUnJFTA3ozq6onkAx9uqCDaGDhccQvb0LNlLYiz4EoAjGTbYfp/
   nl/slaGdA9qBH8apR6nYd2C8f4gEHpq24FemMnwxCAYXivlV4Dwx9TTQWfAAbSVKsAJWDXsMWEsh
   KWGX0F37lqL5972sCWASqmZ7K+/8f4WGp+3WKFF/m00Dkqc5S99ZIucGLntIa7FtGO4N/KxgpUv/
   p3GosvcXN7BCaZV9OPeUJcGEHfjG264h25aI3OFJlp0Aw87pUJJ3siOTGMhd/93H4fD9LQ8F/0eG
   IZibObWpYn+6r0FCf9Uqkcwto5RNu7uY4jmDWg==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRX0011UM19CC70@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 22 Mar 2023 17:03:09 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mw+j7bkkDr7BzNV/FSM3E1G2qrTLcqFhqGjF/WCMBqXlVPft7MhnpfgDhXU1XAlGkEvvc3x+IdzBC/fNKaj05azGGoyookcE2A73WIT1aDgmzkBZ5QV4hphMkchFV2VtYRvTKGhwnfKaZxIKnM4BiPO+fKXwcD8DnHWSDnvFlsi/Kt2kcecfTmYWcDECDvqEZkGzOEf464l7S8kOUkm6y5Ur4qS8UFSamrGUEp7H7jy7fg4W6RojuXZL0TSTC6giBPKaTk1YeROj7VW9l5E/zr5TZncc+z859+alOMIlDMInixtn006cefgiY/OyUmMv8bISmoHJGMFqUjsYh+0nhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hls3ELBTfAPebu+2KYZozBFgc1+NwXVJaxIp2fmyeL4=;
 b=oX/5Yvtfo5qgoF9IhN4cv061c/yU1WBJDtj6MGFe0DZLoGrwhMlpICLSfMAYlMTE5F+wPgeQP+hHdjfo20pILdjsXsRhEAu/hGN0duRL4QqYfOphFBWg+DTCQvFGPg753KpXv6J3bKZZHqtIgyMpwnfPWfAynQTL4yxa8E2rYzyrDSKnvsqphSaVXCo0QbOvfo7fxmfLlZ7CMlpxB0SCQ+2EqkwBHG9BU9AxXkFwzST8ZOjOtdvqLMlPiV2PnrfvXfBuOX/fQrnjKTPhqyy8HcKDz6PWi6MagRNuUG1Icjv8/DU1lTu2SNdsqQFXuSzH+SxXVfL3MOU0zXTR7owpgg==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com; dkim=pass
 header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hls3ELBTfAPebu+2KYZozBFgc1+NwXVJaxIp2fmyeL4=;
 b=AdusP5DMXxj39u9WzxW2k06xK+ds6CzkFg5fzaODk4NmnoziZkQq4kairmMkEiqSEGw1yu5BpPTb16URyhpTjaldENCx4NQ6j8TbD0fYHrDw8aSZh8X/XX4CmMC4ISnkO7UuNFBWEeiyeb37YzsEpFR1Gsaz6bbNh2WwT7BazTVJDZhNxI7p4iCykhmMdjw3YZWYJOD4v2hfaOWhxIfnHy9wzPf5CYrXQYlNTOtFMRqehMvw7btPukAvAwmPbQynRZku/Z3r40iD0C/2IFAXv3bP6voDDI6Ysu7GND8fjCFcExYjqko/f3AYI+OZMIveph6XREbDKFtnuzpREwPvJw==
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Sun, 19 Mar 2023 17:26:39 +0800
Message-id: <20230319092641.41917-8-frank.li@vivo.com>
X-Mailer: git-send-email 2.35.1
In-reply-to: <20230319092641.41917-1-frank.li@vivo.com>
References: <20230319092641.41917-1-frank.li@vivo.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SEZPR06MB5269.apcprd06.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(4636009)(376002)(346002)(136003)(366004)(396003)(39850400004)(451199018)(52116002)(2616005)(478600001)(6486002)(83380400001)(6666004)(316002)(54906003)(8676002)(66476007)(66556008)(66946007)(186003)(26005)(6506007)(6512007)(110136005)(1076003)(4326008)(5660300002)(41300700001)(4744005)(8936002)(38350700002)(38100700002)(2906002)(36756003)(86362001); DIR:OUT;
 SFP:1102;
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2023 09:27:23.7661 (UTC)
X-Source-IP: 40.107.117.114
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10653
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 spamscore=0 adultscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=817 clxscore=101 phishscore=0 priorityscore=180
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303190079 domainage_hfrom=9112
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org,
 ocfs2-devel@oss.oracle.com, Yangtao Li <frank.li@vivo.com>
Subject: [Ocfs2-devel] [PATCH v2,
	RESEND 08/10] ocfs2: convert to kobject_del_and_put()
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
From: Yangtao Li via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Yangtao Li <frank.li@vivo.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: SG2PR01CA0137.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::17) To SEZPR06MB5269.apcprd06.prod.outlook.com
 (2603:1096:101:78::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5269:EE_|SI2PR06MB4012:EE_
X-MS-Office365-Filtering-Correlation-Id: 5488fe64-967d-4777-fe43-08db285c2598
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 kB+NjScSeuCcXXqadgKmgzjfRup8SXEggCkOBKCYxNWB2CCTjV47KY2jcMT9eVQHUVU5LoWDDw6kkCKXp2oh1eAD7DndGmTSWQQBGVna4hDSczA4ZrNDKA4EayL2aSo/Zfd1DwVP7DF5Hq4pJpDVeAclIbG6l00AdRLW0SPqCOFED83eqq3EqauQGha8wq3Fxk55kzunNNtoj+5JuUANhKZeP7Vb5xGhF0evy1rUb0yjnFutTCDJyvD89ZxwD/lfQ01UjtIYD6N+M8RsRG/7C23nF/eU1i3PadCsarzdvR8VVy845bRaF/kZC44sF0Di+ycDkfu6IkXtYXvEpRdnTcTZEZndCs9C3NgUX6yEDgJZrxldh8JajbrZygpOkHGs84lG99J9Jamuih/LE5MDjeL7hv0zPyfftlBNWzIfNnGsgjD1VmcA2+hHz7LJgwMq58i3hT7tALK/kW5ps8GLHXIW3dYzYkl8cwfa8UtMcDwugIx7rj7DAKjmm6CiZbSHj2nnQ2jw6oNM4isCc6HABBxozC+deqdb3vuBMhDcfrY+/yvkc6m8mr+Y4h+7TdoiCgAsa+VQkSgciFeHETAF/YWZJRIA8Wf9x7u3cS5oilGbI6KHhKcl8DdegoEirYxZ3CRa6IkAzuZYa3ehT/IZN2+ZwG5/57dJ5X2H1UgfflDpPbkxoGOUOq16IdkuSJP7RLVlVkNx8UlHWAKqQ78aGg==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?MsMOPiaqI/u31IjWiVCLfrNN6rgv5vXfdVVxDm2FmI23bPXOX/46rv5aoGtv?=
 =?us-ascii?Q?m42AJ6UqXgmRhdT5sChI0JXH4YFnyoK1o2PR892KJZIGZk1/XkLlTslV7r6Q?=
 =?us-ascii?Q?9NIdRZxlUmOR1kgLHF3ejVeC4S3n4OK8KX42soxKcPE4D9r8y9HzfBjBdGIF?=
 =?us-ascii?Q?j8xEwGAx4DXGrpZiw6opxI1rqvJK8zN3IK2kDNYugJhAyneXNj1GvQfCz5lT?=
 =?us-ascii?Q?bNhltrjvM2OgUyzOwmDQQbFu5cJ2DbhrPMdcAfLi9eA5QtJTXIytjRmBrEY/?=
 =?us-ascii?Q?mY9p3T7pLZ+WblUyxO1JrKR+maR41PXeHXGobeBfkLIX48jPvQdN2Jj/wBv8?=
 =?us-ascii?Q?Lc6l1VtY16kXIiWIqZoN/V9/QHfUqlyQbZEXUCjxFaEbQz+FZ9QH65BPq/dq?=
 =?us-ascii?Q?q8Rgm0Emp6ix5ivFaDaJC23OFhEQZKzrsvKxlpLRh8cektsclVE0g3Q8A1Vm?=
 =?us-ascii?Q?dnYFov4wNKFFCaObBIph6EERGVH1wTNkED7cjEB4TWkJQCNWkk3E3KIjEg87?=
 =?us-ascii?Q?ShuKDeRqV3CY23XKkK7ekGVnB1FXz8lP6OSC551kjwGpXF+kDFyb8uM7GC++?=
 =?us-ascii?Q?SYqhjTA3WzensQq0dK+IuUYLkTnP0MMLW5a92799BN19K61otmeLrsOE2K/v?=
 =?us-ascii?Q?MQm9lNPxapbWoIdKQrXcSsClYZ9AkBZmolLfxC5gGrOg1DQzb1AaJd6Ra0ws?=
 =?us-ascii?Q?/DejUB5rQIyhEuAqaRQet/e/BRC80kPKPvwKZj60C9qj5Zz5Yc7Iu197TxcL?=
 =?us-ascii?Q?7X0JyVCa3uoIxZ1XqEz9XkGMH2CC6gdzRAGYzqrWRGNil8Iqxh5zIH0rlGt4?=
 =?us-ascii?Q?QXYtN4UeAA5MLfnlV1WPBCBz9Xi61zpTtrvn+d7wBU28dzWug22ULQFUnAtP?=
 =?us-ascii?Q?jp8h0YGarNWsE/QnhF49ztAkVKr3dPlQqXFeCfPFSPUwMuCPSpT+ZK+ESlAv?=
 =?us-ascii?Q?/hu+POKfDtpGujtcPZRHVQ5zL0T8QVpftb7EvgcutSZ2syDEgPYTVeQ1ieoV?=
 =?us-ascii?Q?4SnHgo+uD8vhPei/z9Avn6JEnCD5DLlSXzCankwffhA0/WbPxvK14SM3oSzu?=
 =?us-ascii?Q?pQ/IaDvPHjY6T42bhDtbmP0kmh4nlGgjOx5dcE8QHN/2bUo8KVsS2vjj0cBe?=
 =?us-ascii?Q?S0oWIxeGtiP8ZJQn3pdy9rYBI6GazZeHpEWz3lN+HkSkpJXFBZWu+udpgdah?=
 =?us-ascii?Q?Emcs19UpCTDRfYIMpJF9tw0+WyYj7HwLKg3AK953m+7DSPwYJYFL+CS8EVH7?=
 =?us-ascii?Q?lu5E3X2d2Ik7ODhYNp0LCpOs7nf5lPemZXR7kjxCQR+aNu+KLP2gbhiSLnMP?=
 =?us-ascii?Q?JSMHGOcqButvePk0Co5INGXOY20c3rTLHLFpBb1P1tmPW+cIhQkZ/xf4xNSQ?=
 =?us-ascii?Q?kifiwvjiqDJTHjjYdPhXmaxxtSBt8oK8YRp+xVZiDcHD8fIb8YryKnzg7Qvp?=
 =?us-ascii?Q?UhhK9WVW3rGM29jLOo4VURJUlKEco6mTNv02rBo6VsSdHF7hgUvYNHWOre/0?=
 =?us-ascii?Q?hdDSO/2310lUfa6Gkm7YHjJcYmzOMyyPb9BoHkAzq8vWcm32FHGrFLy06DlF?=
 =?us-ascii?Q?uk8EptsYoQJW7xZ36FDQqU+eBFvph5cKCplug8WD?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 5488fe64-967d-4777-fe43-08db285c2598
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5269.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 w1YrRh/ffdLb0e6vs+HtYh6XCLIuKCevTIpq5Cdq/MEZag904R4IXMGR63SWw3iu6l/I1iKMncwbcqWTV+5PNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR06MB4012
X-CLX-Response: 1TFkXGxobEQpMehcbEhoRCllEF2MdWxJhbm14AUJZEQpYWBdlUkhyHX9NXht
 IRxEKeE4XYVMeRB9/ZX9FXmkRCnlMF2ATbWEYXGZcWnlyEQpDSBcHGB0RCkNZFwcbGBwRCkNJFx
 oEGhoaEQpZTRdnZnIRCllJFxpxGhAadwYSG3EYEh8QHhl3BhgaBhoRClleF2xseREKSUYXRVhLS
 UZPdUNESEVfRE51QkVZXk9OEQpJRxd4T00RCkNOF0JTaB0dUB95f29/Ul9PRUR/aW4bYFx+TXVj
 GHJ7cGxrEQpYXBcfBBoEGBMaBRsaBBsbGgQbGR4EGR4QGx4aHxoRCl5ZF0h+YkVPEQpNXBcYHxk
 RCkxaF2hpQk1NEQpNThdoEQpMRhdvb2trbGtrEQpCTxdoQ0ZYGBhlZ1xARBEKQ1oXHhoEGxodBB
 sbHQQbGx4RCkJeFxsRCkReFxkRCkRJFx8RCkJcFxsRCl5OFxsRCkJLF2FTHkQff2V/RV5pEQpCS
 RdhUx5EH39lf0VeaREKQkUXZmhiWhJuRmN4UmkRCkJOF2FTHkQff2V/RV5pEQpCTBdlUkhyHX9N
 XhtIRxEKQmwXa19leFlJHVJyYkgRCkJAF2hsBWtnZkh6TUBgEQpCWBdifW95AU8YGXBwexEKTV4
 XGxEKWlgXGBEKeUMXbFBvSUVpHB0eSBgRCllLFxMbGxgRCnBoF3obUFtATB5FQh9rEBoRCnBoF2
 FrZB5sUEdrTR1+EBoRCnBsF2BpWnpTHV97HB5uEB0SEQptfhcbEQpYTRdLESA=
X-CLX-Shades: MLX
X-ServerName: mail-tyzapc01on2114.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.protection.outlook.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: fsOJRcrB-N41Y0YIhL1bztjvo5PrrZ30
X-Proofpoint-GUID: fsOJRcrB-N41Y0YIhL1bztjvo5PrrZ30
X-Mailman-Approved-At: Wed, 22 Mar 2023 17:03:04 +0000
Reporting-Meta:
 AAFq+MFBifVsZW2ODt8od5NKdQucMG8PmwiIiCl2bJ5Vf+U8mEoO56MzZ4z6ub9d
 Y/D7xdYdPIWygZIlOVfF4kZbn5jz0tegBlGIwZ1PoZ3JYpifdinL+MvJYvb1BPRx
 4BMidWj8PjrXu0ZHW9xOGGmRa3JxRVkAegyTDJMj28EpzP8/n0mkwGyRcW74d2QG
 d9dRhjekZLK8ZFhw4NxzNIjachvkNI76iuul4zYtAkqVTH34Xl//1SoW13m9xXu/
 LkWJpULtyc+Yrx6Tx4U3HQIRkQQJ9m6FunHOjeZlI7qhMIYBaBSLakhHQtbA7EkJ
 I92Uno77cswLeSOvnrX8czR4JIIRaNpMRGddJDKJQVLv6DskDuvSbInI5cQG7N1B
 uGMgB+VXP0rLkbWRf0Be28Lr6m/xBzZIShUMy4ZsRuRi410S4oRxVhyKkrU6lkv9
 3WsOiQOtIyhk0nqPivMXXmy9j/qklK6YDioYMI3Wb7TKwz/uS3b38UrPDuNEobMs
 tAJ9Dmt+CG/VQQoYWk5biUyH6GyURjk5jtyi05YpTc7YzQ==

Use kobject_del_and_put() to simplify code.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Yangtao Li <frank.li@vivo.com>
---
 fs/ocfs2/filecheck.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ocfs2/filecheck.c b/fs/ocfs2/filecheck.c
index 1ad7106741f8..fb9cf601245b 100644
--- a/fs/ocfs2/filecheck.c
+++ b/fs/ocfs2/filecheck.c
@@ -198,8 +198,7 @@ void ocfs2_filecheck_remove_sysfs(struct ocfs2_super *osb)
 	if (!osb->osb_fc_ent.fs_fcheck)
 		return;
 
-	kobject_del(&osb->osb_fc_ent.fs_kobj);
-	kobject_put(&osb->osb_fc_ent.fs_kobj);
+	kobject_del_and_put(&osb->osb_fc_ent.fs_kobj);
 	wait_for_completion(&osb->osb_fc_ent.fs_kobj_unregister);
 	ocfs2_filecheck_sysfs_free(&osb->osb_fc_ent);
 }
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
