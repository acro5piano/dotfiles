local ls = require("luasnip")
local snippet = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")

local function exit()
	return i(0)
end

local function rec_ls()
	return sn(
		nil,
		c(1, {
			-- Order is important, sn(...) first would cause infinite loop of expansion.
			t(""),
			sn(nil, { t({ "", "\t\\item " }), i(1), d(2, rec_ls, {}) }),
		})
	)
end

local function copy(args)
	return args[1]
end

local function firstToUpper(args)
	return (args[1]:gsub("^%l", string.upper))
end

local function fileName()
	return vim.api.nvim_buf_get_name(0):match("^.*/(.*).tsx?$")
end

ls.add_snippets("typescriptreact", {
	snippet("ust", {
		t("const ["),
		i(1),
		t(","),
		f(function(args)
			return "set" .. firstToUpper(args[1])
		end, 1),
		t("] = useState("),
		i(2, "false"),
		t(")"),
		exit(),
	}),
	snippet("urf", {
		t("const ref = useRef<HTMLDivElement>(null!)"),
		exit(),
	}),
	snippet("ufo", {
		t({
			"const { register, handleSubmit, formState: { errors, isSubmitting } } = useForm({",
			"  defaultValues: {",
			"    ",
		}),
		i(1),
		t({
			"",
			"  }",
			"})",
		}),
		exit(),
	}),
	snippet("uro", {
		t({ "const router = useRouter()" }),
	}),
	snippet("imv", {
		t({ "const [isModalVisible, setIsModalVisible] = useState(false)" }),
	}),
	snippet("apm", {
		t({
			"<AppModal isOpen={isModalVisible} onRequestClose={() => setIsModalVisible(false)}>",
			"</AppModal>",
		}),
	}),
	snippet("uef", {
		t({
			"useEffect(() => {",
			"}, [])",
		}),
	}),
	snippet("uca", {
		t({
			"useCallback(() => {",
			"}, [])",
		}),
	}),
	snippet("umo", {
		t({
			"useMount(async () => {",
			"})",
		}),
	}),

	snippet("rfn", {
		t("interface "),
		f(fileName),
		t({ "Props {", "" }),
		i(1),
		t({ "", "}", "", "export const " }),
		f(fileName),
		t({ ": React.VFC<" }),
		f(fileName),
		t({ "Props> = ({ " }),
		i(2),
		t({ " }) => {", "return (", "  <div>", "    " }),
		i(3),
		t({ "", "  </div>", ")", "}" }),
		exit(),
	}),
})

ls.add_snippets("typescript", {
	snippet("tst", {
		t({ "import test from 'ava'", "", "test('" }),
		f(function()
			return vim.api.nvim_buf_get_name(0):match("^.*/(.*).test.tsx?$")
		end),
		t({ "', async (t) => {", "  " }),
		i(1),
		t({ "", "})" }),
		exit(),
	}),
	snippet("nxo", {
		t({
			"import { objectType } from 'nexus'",
			"import { baseEntity } from 'src/graphql/types/base/baseEntity'",
			"",
			"export const ",
		}),
		f(fileName),
		t({
			" = objectType({",
			"  name: '",
		}),
		f(function()
			return fileName():gsub("Type", "")
		end),
		t({ "',", "  definition(t) {", "    baseEntity(t)", "    " }),
		i(1),
		t({ "", "  }", "})" }),
		exit(),
	}),
})
